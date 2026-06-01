-- Adapted from tpope/vim-unimpaired's option toggling (s:Toggle, s:option_map,
-- s:CursorOptions). Provides enable/disable/toggle for a set of options keyed
-- by a single letter, used by the [o / ]o / yo mappings.
-- https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim
local M = {}

-- Build enable/disable/toggle handlers for a simple boolean option.
-- `scope` is "global" (set) or "local" (setlocal).
local function bool_spec(option, scope)
  local accessor = scope == "local" and vim.opt_local or vim.opt
  return {
    name = option,
    enable = function()
      accessor[option] = true
    end,
    disable = function()
      accessor[option] = false
    end,
    toggle = function()
      accessor[option] = not accessor[option]:get()
    end,
  }
end

-- cursorline + cursorcolumn toggled together (unimpaired's `x` / `+`).
local cursor_cross = {
  name = "cursorline + cursorcolumn",
  enable = function()
    vim.opt_local.cursorline = true
    vim.opt_local.cursorcolumn = true
  end,
  disable = function()
    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
  end,
  toggle = function()
    local on = not (vim.opt_local.cursorline:get() and vim.opt_local.cursorcolumn:get())
    vim.opt_local.cursorline = on
    vim.opt_local.cursorcolumn = on
  end,
}

-- letter -> { enable, disable, toggle }
local specs = {
  c = bool_spec("cursorline", "local"),
  ["-"] = bool_spec("cursorline", "local"),
  ["_"] = bool_spec("cursorline", "local"),
  u = bool_spec("cursorcolumn", "local"),
  ["|"] = bool_spec("cursorcolumn", "local"),
  h = bool_spec("hlsearch", "global"),
  i = bool_spec("ignorecase", "global"),
  l = bool_spec("list", "local"),
  n = bool_spec("number", "local"),
  r = bool_spec("relativenumber", "local"),
  s = bool_spec("spell", "local"),
  w = bool_spec("wrap", "local"),
  z = bool_spec("foldenable", "local"),

  b = {
    name = "background",
    enable = function()
      vim.o.background = "light"
    end,
    disable = function()
      vim.o.background = "dark"
    end,
    toggle = function()
      vim.o.background = vim.o.background == "dark" and "light" or "dark"
    end,
  },

  d = {
    name = "diff",
    enable = function()
      vim.cmd("diffthis")
    end,
    disable = function()
      vim.cmd("diffoff")
    end,
    toggle = function()
      vim.cmd(vim.o.diff and "diffoff" or "diffthis")
    end,
  },

  v = {
    name = "virtualedit",
    enable = function()
      vim.opt.virtualedit:append("all")
    end,
    disable = function()
      vim.opt.virtualedit:remove("all")
    end,
    toggle = function()
      if vim.o.virtualedit:find("all") then
        vim.opt.virtualedit:remove("all")
      else
        vim.opt.virtualedit:append("all")
      end
    end,
  },

  x = cursor_cross,
  ["+"] = cursor_cross,
}

-- Letters exposed for setting up the [o / ]o / yo mappings.
M.letters = vim.tbl_keys(specs)

local function run(letter, action)
  local spec = specs[letter]
  if spec then
    spec[action]()
  end
end

-- Human-readable option name bound to `letter` (for keymap descriptions).
function M.name(letter)
  local spec = specs[letter]
  return spec and spec.name or letter
end

-- Enable the option bound to `letter` ([o<letter>).
function M.enable(letter)
  run(letter, "enable")
end

-- Disable the option bound to `letter` (]o<letter>).
function M.disable(letter)
  run(letter, "disable")
end

-- Toggle the option bound to `letter` (yo<letter>).
function M.toggle(letter)
  run(letter, "toggle")
end

return M
