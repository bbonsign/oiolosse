-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- ctrl+L for localleader
vim.g.maplocalleader = ""
vim.g.VM_leader = "" -- for "mg979/vim-visual-multi" in plugins/multicursors.lua

local opt = vim.opt

opt.cmdheight = 0
-- Draw vertical line one column past textwidth
opt.colorcolumn = "+1"
opt.conceallevel = 0
opt.mousemoveevent = true
opt.number = false
opt.relativenumber = false
opt.textwidth = 100
opt.foldlevel = 100

vim.g.snacks_animate = false

-- vim.opt.foldtext = "v:lua.require'bb.foldtext'.foldtext()"
