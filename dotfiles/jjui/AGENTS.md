# jjui Lua Configuration

This directory contains Lua configuration for [jjui](https://github.com/idursun/jjui), a TUI for Jujutsu VCS.

## Type Stubs

`types/jjui.lua` provides LuaLS type annotations for the entire jjui Lua scripting API. The `.luarc.json` configures lua-language-server to use it. All jjui globals (`jj`, `flash`, `context`, `revisions`, `revset`, `jjui.*`, etc.) are typed there.

When writing or modifying Lua files in this directory, use the types from `types/jjui.lua` — do NOT add `---@diagnostic disable: undefined-global` comments.

## Structure

- `config.lua` — entrypoint; jjui calls `setup(config)` at startup
- `plugins/my_binds.lua` — keybinding overrides via `config.bind()`
- `plugins/my_actions.lua` — auto-loads all action files from `plugins/actions/`
- `plugins/actions/` — each `.lua` file returns a single `ActionDef` table
- `types/jjui.lua` — LuaLS type stubs (not loaded by jjui at runtime)

## Writing Actions

Each file in `plugins/actions/` returns an `ActionDef` table:

```lua
---@type ActionDef
return {
  name = "my-action",
  fn = function()
    -- jjui globals are available here: jj(), flash(), context, revisions, etc.
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    jj("log", "-r", change_id)
  end,
  opts = {
    seq = { "space", "x" },  -- key sequence trigger
    scope = "revisions",      -- Scope alias provides autocompletion
    desc = "my action",
  },
}
```

Actions can also use `key` instead of `seq` for single-key bindings:

```lua
opts = {
  key = "X",           -- or key = {"X", "x"} for multiple keys
  scope = "revisions",
}
```

The `ActionDef` class and `Scope` alias in the type stubs give autocompletion for all fields.

## Writing Binds

Binds in `plugins/my_binds.lua` remap keys to existing built-in actions:

```lua
{
  action = "revisions.open_abandon",  -- built-in action ID
  key = "A",
  scope = "revisions",
  desc = "abandon",
}
```

Use `key = "__none__"` to unbind a default keybinding.

## Key Conventions

- Key sequences use `"space"` for the space key (not `" "`).
- Modifier keys: `"ctrl+x"`, `"alt+x"`, `"shift+x"`.
- The `Scope` type alias in `types/jjui.lua` lists all valid scopes.

## jjui API Quick Reference

- **Commands**: `jj(...)` (sync), `jj_async(...)` (fire-and-forget), `jj_interactive(...)` (terminal)
- **UI**: `flash()`, `choose()`, `input()`, `exec_shell()`
- **Context**: `context.change_id()`, `context.commit_id()`, `context.file()`, `context.checked_commit_ids()`, etc.
- **Revisions**: `revisions.current()`, `revisions.checked()`, `revisions.refresh()`, `revisions.navigate()`
- **Revset**: `revset.set()`, `revset.reset()`, `revset.current()`, `revset.default()`
- **Wait**: `wait_close()` (yields until sub-view closes), `wait_refresh()` (yields until refresh)
- **Generated actions**: `jjui.revisions.open_rebase()`, `jjui.ui.open_revset()`, etc.
- **Config** (in `setup()`): `config.action()`, `config.bind()`, `config.repo`, `config.terminal`

See `types/jjui.lua` for full signatures and documentation.
