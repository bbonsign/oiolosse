"""Read configured hints; Umbriel remains the sole key/action executor."""

import json
import os
import re
import signal
import subprocess
import sys
import time
from pathlib import Path

import tomllib


def snapshot(path, submap):
    model = {"submap": submap, "bindings": []}
    if submap is None:
        return model
    try:
        with Path(path).expanduser().open("rb") as source:
            content = source.read(1024 * 1024 + 1)
        if len(content) > 1024 * 1024:
            raise ValueError("Binding file exceeds 1 MiB")
        bindings = tomllib.loads(content.decode("utf-8")).get("keybinds", {})
        if not isinstance(bindings, dict):
            raise TypeError("Expected a [keybinds] table")
        for chord, entry in bindings.items():
            match = re.fullmatch(r"submap\[([^\]]+)\],?(.+)", chord)
            layer, key = match.groups() if match else ("", chord.strip())
            action = entry.get("action") if isinstance(entry, dict) else entry
            # Only the top layer matches, plus default-context emergency reset.
            if layer != submap and not (layer == "" and action == "submap:reset"):
                continue
            if not isinstance(action, str):
                continue
            # Umbriel folds letter keysyms; uppercase alone does not mean Shift.
            tokens = key.split("+")
            if len(tokens[-1]) == 1 and tokens[-1].isascii() and tokens[-1].isalpha():
                tokens[-1] = tokens[-1].lower()
            key = "+".join(tokens)
            row = {"key": key, "action": action}
            if isinstance(entry, dict) and isinstance(entry.get("submap"), str):
                row["after"] = entry["submap"]
            model["bindings"].append(row)
        model["bindings"].sort(key=lambda row: row["key"])
    except (OSError, ValueError, TypeError, UnicodeError) as error:
        model["error"] = f"Cannot read bindings: {error}"
    return model


def publish(model):
    print(json.dumps(model, ensure_ascii=False), flush=True)


def stop(_signum, _frame):
    raise SystemExit(0)


def watch(path):
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    while True:
        process = None
        try:
            # CLI sends an initial snapshot, so there is no query/subscribe race.
            process = subprocess.Popen(
                ["umbriel", "subscribe", "submap"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
            )
            while line := process.stdout.readline(65537):
                if len(line) > 65536:
                    raise ValueError("Oversized submap event")
                try:
                    event = json.loads(line)
                except (ValueError, UnicodeError):
                    continue
                if not isinstance(event, dict) or event.get("event") != "submap":
                    continue
                if "data" in event and (
                    event["data"] is None or isinstance(event["data"], str)
                ):
                    publish(snapshot(path, event["data"]))
            publish({"error": "Umbriel subscription disconnected; retrying"})
        except (OSError, ValueError) as error:
            publish({"error": str(error)})
        finally:
            if process is not None:
                process.terminate()
                try:
                    process.wait(timeout=2)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait()
                process.stdout.close()
        # Retry only after failure; never poll an idle healthy compositor.
        time.sleep(2)


if __name__ == "__main__":
    binding_file = sys.argv[1]
    if len(sys.argv) == 4 and sys.argv[2] == "--snapshot":
        publish(snapshot(binding_file, json.loads(sys.argv[3])))
    elif os.environ.get("UMBRIEL_SOCKET") or os.environ.get("WAYLAND_DISPLAY"):
        watch(binding_file)
    else:
        publish({"error": "Not in an Umbriel/Wayland session"})
