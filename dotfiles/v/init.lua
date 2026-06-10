vim.loader.enable()

if vim.fn.has("nvim-0.12") == 1 then
  require("vim._core.ui2").enable()
end

-- Neovim's default `<C-L>` mapping (nohlsearch|diffupdate|redraw) is a *complete*
-- mapping that shadows <localleader> (Ctrl-L), so <localleader>... sequences never
-- fire. Remove it so Ctrl-L works purely as the local leader.
pcall(vim.keymap.del, "n", "<C-L>")
vim.g.mapleader = " " -- Use `<Space>` as <Leader> key
vim.g.maplocalleader = "" -- ctrl+L for localleader

-- Define config table to be able to pass data between scripts
-- It is a global variable which can be use both as `_G.Config` and `Config`
_G.Config = {}

Config.augroup = function(name)
  return vim.api.nvim_create_augroup("bb_" .. name, { clear = true })
end

-- Load now to have 'mini.misc' available for custom loading helpers.
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
local misc = require("mini.misc")
-- Loading helpers used to organize config into fail-safe parts. Example usage:
-- - `now` - execute immediately. Use for what must be executed during startup.
--   Like colorscheme, statusline, tabline, dashboard, etc.
-- - `later` - execute a bit later. Use for things not needed during startup.
-- - `now_if_args` - use only if needed during startup when Neovim is started
--   like `nvim -- path/to/file`, but otherwise delaying is fine.
-- - Others are better used only if the above is not enough for good performance.
--   Use only if you are comfortable with adding complexity to your config:
--   - `on_event` - execute once on a first matched event. Like "delay until
--     first Insert mode enter": `on_event('InsertEnter', function() ... end)`.
--   - `on_filetype` - execute once on a first matched filetype. Like "delay
--     until first Lua file": `on_filetype('lua', function() ... end)`.
Config.now = function(f)
  misc.safely("now", f)
end
Config.later = function(f)
  misc.safely("later", f)
end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f)
  misc.safely("event:" .. ev, f)
end
Config.on_filetype = function(ft, f)
  misc.safely("filetype:" .. ft, f)
end

-- Define custom `vim.pack.add()` hook helper. Plugin data is passed as
-- argument to the callback. See `:h vim.pack-events`.
-- Example usage: see 'plugin/40_plugins.lua'.
-- If any plugin requires installation hooks, add them after this function
-- and before the first `vim.pack.add()` call.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev.data)
  end
  vim.api.nvim_create_autocmd("PackChanged", {
    group = Config.augroup("pack_changed"),
    pattern = "*",
    callback = f,
    desc = desc,
  })
end

require("plugins.colors")

Config.icons = {
  misc = {
    dots = "󰇘",
  },
  ft = {
    octo = " ",
    gh = " ",
    ["markdown.gh"] = " ",
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}
