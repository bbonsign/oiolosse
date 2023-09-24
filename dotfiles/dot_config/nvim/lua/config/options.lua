-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

vim.g.VM_leader = ";" -- for "mg979/vim-visual-multi" in plugins/multicursors.lua
vim.g.maplocalleader = ";"

opt.relativenumber = false
opt.number = false
opt.conceallevel = 0
