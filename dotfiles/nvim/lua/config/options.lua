-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = ";"
vim.g.VM_leader = ";" -- for "mg979/vim-visual-multi" in plugins/multicursors.lua

local opt = vim.opt

opt.cmdheight = 0
opt.conceallevel = 0
opt.number = false
opt.relativenumber = false

vim.g.snacks_animate = false

-- set to `true` to follow the main branch
-- you need to have a working rust toolchain to build the plugin
-- in this case.
-- vim.g.lazyvim_blink_main = true

-- vim.opt.foldtext = "v:lua.require'bb.foldtext'.foldtext()"
