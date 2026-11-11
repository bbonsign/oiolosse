"""Run with nu 0.116.1+ and fzf on PATH: python3 dotfiles/nushell/tests/repl.py."""

import fcntl
import json
import os
from pathlib import Path
import pty
import select
import shutil
import signal
import struct
import tempfile
import termios
import time


ROOT = Path(__file__).resolve().parents[3]
NU = shutil.which("nu")
assert NU and shutil.which("fzf"), "nu and fzf must be on PATH"

FIXTURES = """
def branches [] { [main maple] }
def choose [branch?: string@branches --raw] {}
alias co = choose
def display-completion [] {
  [{value: '"my file"' display_override: "friendly label"}]
}
def display-command [arg: string@display-completion] {}
$env.config.keybindings = ($env.config.keybindings | append {
  name: capture_test_buffer
  modifier: control
  keycode: char_g
  mode: [emacs vi_insert vi_normal]
  event: {send: executehostcommand cmd: '{buffer: (commandline) cursor: (commandline get-cursor)} | to json | save -f $env.TEST_CAPTURE'}
})
"""

CASES = [
    dict(name="fuzzy", text="choose mi", expected="choose main", cursor=11),
    dict(name="cursor", text="choose ma --raw", left=6,
         expected="choose main --raw", cursor=11),
    dict(name="unicode", text="echo é | choose mi",
         expected="echo é | choose main", cursor=20),
    dict(name="no-results", text="choose zz", expected="choose zz", cursor=9),
    dict(name="menu", text="choose mi", key=b"\x0f", expected="choose main", cursor=11),
    dict(name="cancel", text="choose ma", picker=b"\x1b", expected="choose ma", cursor=9),
    dict(name="cancel-menu", text="choose ma", key=b"\x0f", picker=b"\x1b",
         expected="choose ma", cursor=9),
    dict(name="accept", text="choose ma", picker=b"\r", expected="choose main", cursor=11),
    dict(name="quoted", text="display-command ", filter="friendly",
         expected='display-command "my file"', cursor=25),
    dict(name="flag", text="choose --ra", filter="raw", expected="choose --raw ", cursor=13),
    dict(name="alias", text="co", key=b"\x00", expected="choose ", cursor=7),
    dict(name="history", seed=["echo héllo", "echo unrelated"],
         text="echo é | echo hé", key=b"\x1bp", expected="echo é | echo héllo", cursor=19),
]


def check(case, directory, config):
    capture = directory / "buffer.json"
    pid, fd = pty.fork()
    if pid == 0:
        os.environ.update(
            NU_LIB_DIRS=str(ROOT / "dotfiles/nushell/scripts"),
            XDG_CONFIG_HOME=str(directory),
            XDG_DATA_HOME=str(directory),
            TERM="xterm-256color",
            TEST_CAPTURE=str(capture),
            FZF_DEFAULT_OPTS=("--height=10 --layout=reverse" if "picker" in case
                              else "--filter=" + case.get("filter", "main")),
        )
        os.execv(NU, [NU, "--config", str(config), "--env-config", "/dev/null", "-i"])

    transcript = bytearray()

    def drain(seconds):
        deadline = time.monotonic() + seconds
        while time.monotonic() < deadline:
            if select.select([fd], [], [], 0.02)[0]:
                data = os.read(fd, 65536)
                # Answer the cursor-position queries Nu and fzf send to a terminal.
                if b"\x1b[6n" in data:
                    os.write(fd, b"\x1b[1;1R")
                transcript.extend(data)

    try:
        fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 30, 120, 0, 0))
        drain(0.8)
        for command in case.get("seed", []):
            os.write(fd, command.encode() + b"\r")
            drain(0.4)
        os.write(fd, case["text"].encode())
        drain(0.3)
        for _ in range(case.get("left", 0)):
            os.write(fd, b"\x1b[D")
            drain(0.03)
        os.write(fd, case.get("key", b"\x0a"))
        drain(0.8)
        if "picker" in case:
            os.write(fd, case["picker"])
            drain(0.5)
        os.write(fd, b"\x07")
        drain(0.5)
        assert capture.exists(), transcript.decode(errors="replace")
        actual = json.loads(capture.read_text())
        assert actual == dict(buffer=case["expected"], cursor=case["cursor"]), actual
        assert b"Positional completer input deprecated" not in transcript
        assert b"Error:" not in transcript, transcript.decode(errors="replace")
        print(f"PASS {case['name']}", flush=True)
    finally:
        os.kill(pid, signal.SIGTERM)
        os.close(fd)
        os.waitpid(pid, 0)


with tempfile.TemporaryDirectory(prefix="nu-completions-") as temporary:
    base = Path(temporary)
    config = base / "config.nu"
    config.write_text((ROOT / "modules/features/shells/nushell/config.nu").read_text() + FIXTURES)
    for case in CASES:
        directory = base / case["name"]
        directory.mkdir()
        check(case, directory, config)

print("Interactive completion checks passed")
