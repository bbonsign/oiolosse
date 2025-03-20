-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "<Leader>l")
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
-- vim.keymap.del("n", "<A-h>")
-- vim.keymap.del("n", "<A-j>")
-- vim.keymap.del("n", "<A-k>")
-- vim.keymap.del("n", "<A-l>")

-- Overrides <C-I> too
-- vim.keymap.set("n", "<Tab>", "za", { desc = "Toggle Fold" })

vim.keymap.set("n", "<Leader>LL", "<cmd>Lazy<CR>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>LN", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })

-- Use the blackhole register "_ by default for x
vim.keymap.set({ "n", "v" }, "x", '"_x')

-- To complement the default <C-y> for scrolling text up/down
-- with out moving cursor
vim.keymap.set("n", "<C-h>", "<C-e>")
vim.keymap.set("n", "<C-j>", "<C-e>")
vim.keymap.set("n", "<C-k>", "<C-y>")

vim.keymap.set({ "n", "v" }, "<Leader>p", '"0p', { desc = "Paste last yank" })
vim.keymap.set({ "n", "v" }, "<Leader>P", '"0P', { desc = "Paste last yank" })

vim.keymap.set("n", "<Leader>=", ":.lua<CR>", { desc = "Lua eval" })
vim.keymap.set("n", "g=", ":.lua<CR>", { desc = "Lua eval" })
vim.keymap.set("v", "<Leader>=", ":lua<CR>", { desc = "Lua eval" })
vim.keymap.set("v", "=", ":lua<CR>", { desc = "Lua eval" })

-- Center line when jumping to search results
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
-- search the visual selection
vim.keymap.set("x", "<CR>", '""y/<C-r>"<CR>N', { desc = "Search word under cursor" })
vim.keymap.set("n", "<CR>", "*N", { desc = "Search word under cursor" })

vim.keymap.set({ "n", "v" }, "g.", "g`.", { desc = "Goto last edit" })

vim.keymap.set("n", "Q", "@q", { desc = 'Macro in "q' })
vim.keymap.set("v", "Q", [[:norm @q<CR>]], { desc = 'Macro in "q' })

vim.keymap.set("i", [[<C-\>]], "λ", { desc = "Insert λ characer" })
-- vim.keymap.set("i", [[<C-j>]], "|>", { desc = "|> Pipe" })

vim.keymap.set("i", "<C-e>", "<Esc>A", { desc = "End of line" })
vim.keymap.set("i", "<C-a>", "<Esc>I", { desc = "Beg of line" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Left" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Right" })
vim.keymap.set("n", "<C-e>", "$", { desc = "End of line" })
vim.keymap.set("n", "<C-a>", "^", { desc = "Beg of line" })
vim.keymap.set("v", "<C-e>", "g_", { desc = "End of line" })
vim.keymap.set("v", "<C-a>", "^", { desc = "Beg of line" })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Beg of line" })
vim.keymap.set("c", "<C-b>", "<Left>", { desc = "Left" })
vim.keymap.set("c", "<C-f>", "<Right>", { desc = "Right" })

-- -- toggle options
-- vim.keymap.set("n", "<Leader>uc", ":set cursorline!<CR>", { desc = "Toggle cursorline" })
Snacks.toggle.option("cursorline", { name = "Cursorline", global = true }):map("<Leader>uc")

Snacks.toggle
  .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline", global = true })
  :map("<leader>ut")

vim.keymap.set("n", "<Leader>uS", function()
  if vim.o.laststatus == 3 then
    vim.o.laststatus = 0
  else
    vim.o.laststatus = 3
  end
end, { desc = "Toggle Statusline" })

vim.keymap.set("n", "<Leader>a:", "A;<Esc>", { desc = "Append ; to line" })

vim.keymap.set("n", "<Leader>fs", ":w<CR>", { desc = "Write file" })
vim.keymap.set("n", "<Leader>fw", ":w<CR>", { desc = "Write file" })
vim.keymap.set("n", "<Leader>fR", ":earlier 1f<CR>", { desc = "Revert to last write" })

vim.keymap.set("n", "<Leader>w=", "<C-w>=", { desc = "Balance splits" })
vim.keymap.set("n", "<Leader>wc", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<Leader>wH", "<C-w>H", { desc = "Move left" })
vim.keymap.set("n", "<Leader>wh", "<C-w>h", { desc = "Change left" })
vim.keymap.set("n", "<Leader>wJ", "<C-w>J", { desc = "Move down" })
vim.keymap.set("n", "<Leader>wj", "<C-w>j", { desc = "Change down" })
vim.keymap.set("n", "<Leader>wK", "<C-w>K", { desc = "Move up" })
vim.keymap.set("n", "<Leader>wk", "<C-w>k", { desc = "Change up" })
vim.keymap.set("n", "<Leader>wL", "<C-w>L", { desc = "Move right" })
vim.keymap.set("n", "<Leader>wl", "<C-w>l", { desc = "Change right" })
vim.keymap.set("n", "<Leader>wo", "<C-w>o", { desc = "Only window" })
vim.keymap.set("n", "<Leader>wq", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<Leader>wR", "<C-w>R", { desc = "Rotate windows <-" })
vim.keymap.set("n", "<Leader>wr", "<C-w>r", { desc = "Rotate windows ->" })
vim.keymap.set("n", "<Leader>ws", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<Leader>wt", ":tab split<CR>", { desc = "New tab w/ current buf" })
vim.keymap.set("n", "<Leader>wv", ":vsplit<CR>", { desc = "Veritcal split" })
vim.keymap.set("n", "<Leader>wW", "<C-w>W", { desc = "Other window <-" })
vim.keymap.set("n", "<Leader>ww", "<C-w>w", { desc = "Other window ->" })

-- https://github.com/nvzone/menu
vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default", { border = true })
end, {})

vim.keymap.set("n", "<RightMouse>", function()
  vim.cmd.exec('"normal! \\<RightMouse>"')

  local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  require("menu").open(options, { mouse = true, border = true })
end, {})

vim.cmd([[cabbr Wa wa]])
vim.cmd([[cabbr Wq wq]])
