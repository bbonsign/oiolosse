# Submap Hints

Personal Luau plugin for Umbriel. Entering a submap opens a passive bottom-center
panel; nested transitions replace the hints; leaving the last layer closes it.
Umbriel executes every binding. The panel has no keyboard focus, no click
actions, and no outside-click dismissal. It is persistent so opening another
Noctalia panel does not replace it.

## Compatibility and source of truth

Designed against this flake's Noctalia **5.2.1** revision
[`889757c`](https://github.com/noctalia-dev/noctalia/commit/889757c0fa2af5cd5cbd67afa7b86fc6ac5a6b51) and Umbriel revision
[`1a58290`](https://github.com/noctalia-dev/umbriel/commit/1a5829066148394b36bc45fe76e768685e5a5369). Requires plugin API **24**
(direct-argv IPC; passive focus is API 10, persistence API 11), `umbriel`, and
Python **3.11+** with `tomllib`. The home profile already includes Python 3.12.
This is not a legacy QML/v4 plugin.

Umbriel has no binding-enumeration or per-binding description API. Hints come
from the actual `[keybinds]` table in `~/.config/umbriel/keybinds.toml`, not
`wlr-which-key/config.yaml`. Labels show the configured action/command and
submap transitions; `↩` marks a post-action reset. No independent dispatch or
duplicated hint list is involved.

Keys use the theme's primary accent; action descriptions use tertiary and
entries into another submap use secondary (including post-action transitions).
Previous-layer navigation is muted; a post-action reset keeps the action color.
Escape rows are hidden from the panel; their Umbriel bindings still work.

`bindings_file` can select another **single binding file**. This deliberately
does not resolve Umbriel includes, defaults, aliases, or runtime binding
overrides. Keep all submap bindings in that file and validate with Umbriel;
invalid/unloaded bindings on disk cannot be distinguished from active bindings.
It is re-read on every submap event. After editing, reload Umbriel and leave/re-enter
the layer to refresh the hints. Missing/malformed files show an error; unknown
layers show an empty state. Session lock/inhibition availability is not exposed
by the subscription: hints describe configured bindings, not security eligibility.

The subscriber receives an initial active-layer snapshot, closes stale hints
on disconnect, and retries after two seconds. One service owns the helper and
its subscription; host unload terminates them. No idle compositor polling.

## Repository integration (not activation)

The existing `mise run dots` links the whole `dotfiles/noctalia` directory.
`config.toml` enables `bbonsign/submap-hints` from the path source
`~/.config/noctalia/plugins`. Nothing is published or installed from a catalog.
After you choose to apply those dotfiles on the laptop, reload Noctalia and
Umbriel using your normal workflow. Do not run Home Manager activation just to
test this plugin.

Umbriel's `Mod+Space` now enters `leader`, replacing its wlr-which-key launch.
The leader retains useful application/workspace shortcuts and nested bar,
colorpicker, notifications, run, windows, workspaces, and power menus. The
screenshot submap bindings are currently commented out, although leader's `s`
still targets that layer. Niri-only sharing/balancing commands are not copied into Umbriel.
The Niri/Sway wlr-which-key configuration remains unchanged for those sessions.

**Reset pops one layer**, not the whole stack. Each submenu entry uses
`{ action = "submap:reset", submap = "<menu>" }`: pop the parent, then push the
submenu. This keeps one active layer, so every final action's `submap = "reset"`
returns to default, including window/workspace movement. These are one-shot
bindings, not repeatable in-menu actions.

BackSpace explicitly replaces a submenu with its parent (`leader`), except in
leader where it clears the active notification. Escape resets the current
layer and returns to default. Explicit `Shift+…` binds are used for shifted
shortcuts because Umbriel case-folds letter keysyms. Unbound keys pass through.

## Checks

From the repository root:

```sh
python3 dotfiles/noctalia/plugins/submap-hints/test_bindings.py
noctalia plugins lint dotfiles/noctalia/plugins/submap-hints
noctalia config validate dotfiles/noctalia/config.toml
umbriel config validate -c dotfiles/umbriel/config.toml
python3 dotfiles/noctalia/plugins/submap-hints/bindings.py \
  dotfiles/umbriel/keybinds.toml --snapshot '"leader"'
```

Verified in the orb: three CLI regression tests, Luau compilation, host settings
lint, and both config validators. Noctalia's standalone config validator warns
about the existing world-clock widget because its external plugin is not loaded.
The official repository validator additionally requests distribution metadata
and a thumbnail; those are intentionally out of scope for this local plugin.

The locked Noctalia host also loaded/rendered the plugin on headless Sway at
1280×720 using the real Umbriel CLI with a socket event fixture. Inspected leader,
windows, empty, binding-file error, and reset states. Exercised rapid transitions,
disable/re-enable, service hot reload, and stream disconnect/reconnect; one reader
and subscriber remained. A Noctalia dmenu still returned `beta` after a nested
hint transition and injected typing, demonstrating that the hint panel did not
steal its keyboard focus. This is **not** compositor binding execution evidence:
Umbriel's headless renderer failed to allocate buffers without `/dev/udmabuf`.

Laptop acceptance checks: verify `noctalia --version`, then enter `Mod+Space`,
press `w`, exercise movement, and confirm return to default. Re-enter and check
BackSpace back to leader and Escape out. Repeat with another submenu and check
leader's BackSpace notification action. Confirm the compositor still receives the
next keystroke and an unbound key reaches a focused client. Check multiple
outputs, scaling, fullscreen, theme, config reload, disable/re-enable, and
compositor disconnect/reconnect. Do not exercise power actions merely to test
rendering.
