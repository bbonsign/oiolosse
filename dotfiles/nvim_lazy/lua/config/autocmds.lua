-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- local function augroup(name)
--   return vim.api.nvim_create_augroup("bb_" .. name, { clear = true })
-- end
-- --
-- -- Highlight current line when entering buffer
-- vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
--   group = augroup("highlight_on_enter"),
--   callback = function()
--     (vim.hl or vim.highlight).on_yank()
--   end,
-- })
vim.api.nvim_create_user_command("TermHl", function()
  vim.api.nvim_open_term(0, {})
end, { desc = "Highlights ANSI termcodes in curbuf" })
