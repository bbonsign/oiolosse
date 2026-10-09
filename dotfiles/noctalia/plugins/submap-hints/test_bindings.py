"""Regression checks for the hint reader's command-line contract."""

import json
import os
import select
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


class BindingHintsTest(unittest.TestCase):
    def read_snapshot(self, path, layer):
        output = subprocess.check_output(
            [
                sys.executable,
                str(Path(__file__).with_name("bindings.py")),
                str(path),
                "--snapshot",
                json.dumps(layer),
            ],
            text=True,
            timeout=5,
        )
        return json.loads(output)

    def test_only_top_layer_and_global_reset_with_one_shot_metadata(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bindings.toml"
            path.write_text("""[keybinds]
"Mod+Space" = "submap:outer"
"Mod+Escape" = "submap:reset"
"submap[outer],i" = "submap:inner"
"submap[inner],x" = { action = "spawn:printf 'a#b'", submap = "reset" }
"submap[inner],Escape" = "submap:reset"
"submap[inner]Shift+R" = "window-close"
"submap[other],z" = "window-close"
""")
            self.assertEqual(
                self.read_snapshot(path, "inner"),
                {
                    "submap": "inner",
                    "bindings": [
                        {"key": "Escape", "action": "submap:reset"},
                        {"key": "Mod+Escape", "action": "submap:reset"},
                        {"key": "Shift+r", "action": "window-close"},
                        {"key": "x", "action": "spawn:printf 'a#b'", "after": "reset"},
                    ],
                },
            )
            self.assertEqual(
                self.read_snapshot(path, None), {"submap": None, "bindings": []}
            )
            self.assertEqual(
                self.read_snapshot(path, "outer")["bindings"],
                [
                    {"key": "Mod+Escape", "action": "submap:reset"},
                    {"key": "i", "action": "submap:inner"},
                ],
            )

    def test_file_errors_are_distinct_from_empty_and_reset(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bindings.toml"
            self.assertIn("error", self.read_snapshot(path, "inner"))
            path.write_text('[keybinds]\n"submap[other],x" = "window-close"\n')
            self.assertEqual(
                self.read_snapshot(path, "inner"), {"submap": "inner", "bindings": []}
            )
            path.write_text("[keybinds]\ninvalid TOML")
            self.assertIn("error", self.read_snapshot(path, "inner"))
            self.assertNotIn("error", self.read_snapshot(path, None))

    def test_stream_reset_disconnect_and_reconnect(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            bindings = root / "bindings.toml"
            bindings.write_text('[keybinds]\n"submap[inner],x" = "window-close"\n')
            # A CLI fixture exercises the public stream, not private callbacks.
            cli = root / "umbriel"
            cli.write_text(f"""#!{sys.executable}
import json
import time
print('malformed', flush=True)
print('{{"event":"submap"}}', flush=True)
for layer in ['inner', None]:
    print(json.dumps({{"event": "submap", "data": layer}}), flush=True)
time.sleep(0.05)
""")
            cli.chmod(0o755)
            process = subprocess.Popen(
                [
                    sys.executable,
                    str(Path(__file__).with_name("bindings.py")),
                    str(bindings),
                ],
                stdout=subprocess.PIPE,
                bufsize=0,
                env={
                    **os.environ,
                    "PATH": directory + os.pathsep + os.environ["PATH"],
                    "UMBRIEL_SOCKET": str(root / "socket"),
                },
            )

            def next_model():
                self.assertTrue(
                    select.select([process.stdout], [], [], 5)[0],
                    "No stream snapshot within five seconds",
                )
                return json.loads(process.stdout.readline())

            try:
                first = next_model()
                self.assertEqual(
                    first,
                    {
                        "submap": "inner",
                        "bindings": [
                            {"key": "x", "action": "window-close"},
                        ],
                    },
                )
                self.assertEqual(next_model(), {"submap": None, "bindings": []})
                disconnected = next_model()
                self.assertIn("error", disconnected)
                self.assertNotIn("submap", disconnected)
                self.assertEqual(next_model(), first)
            finally:
                process.terminate()
                process.wait(timeout=5)
                process.stdout.close()


if __name__ == "__main__":
    unittest.main()
