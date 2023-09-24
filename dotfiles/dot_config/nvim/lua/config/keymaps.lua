-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "<leader>l")

map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Use the blackhole register "_ by deiault for x
map({ "n", "v" }, "x", '"_x')

-- Center line when jumping to search results
map("n", "n", "nzz")
map("n", "N", "Nzz")

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
map({ "n", "x" }, "<CR>", "*N", { desc = "Search word under cursor" })

map("n", "Q", "@q", { desc = 'Macro in "q' })
map("v", "Q", [[:norm @q<CR>]], { desc = 'Macro in "q' })

map("i", [[<C-\>]], "λ", { desc = "Insert λ characer" })

-- shortcuts for ctrl-a and ctrl-e in insert/normalcommand mode
map("i", "<C-e>", "<Esc>A", { desc = "End of line" })
map("i", "<C-a>", "<Esc>I", { desc = "Beg of line" })
map("n", "<C-e>", "$", { desc = "End of line" })
map("n", "<C-a>", "^", { desc = "Beg of line" })
map("v", "<C-e>", "g_", { desc = "End of line" })
map("v", "<C-a>", "^", { desc = "Beg of line" })
map("c", "<C-e>", "<End>", { desc = "End of line" })
map("c", "<C-a>", "<Home>", { desc = "Beg of line" })

-- stylua: ignore start
-- toggle options
-- Taken from the default <leader>u prefixed keymaps, to also have <leader>t versions
map("n", "<leader>tf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>ts", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>tw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>tl", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>td", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
map("n", "<leader>tc", ":set cursorline!<CR>", { desc = "Toggle cursorline" })
map("n", "<leader>uc", ":set cursorline!<CR>", { desc = "Toggle cursorline" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>tC", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
map("n", "<leader>uC", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

if vim.lsp.inlay_hint then
  map("n", "<leader>th", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end
-- stylua: ignore end

map("n", "<leader>a:", "A;<Esc>", { desc = "Append ; to line" })

map("n", "<leader>bb", ":Telescope buffers<CR>", { desc = "Telescope buffers" })

map("n", "<leader>fs", ":w<CR>", { desc = "Write file" })
map("n", "<leader>fw", ":w<CR>", { desc = "Write file" })
map("n", "<leader>fR", ":earlier 1f<CR>", { desc = "Revert to last write" })

map("n", "<leader>w=", "<C-w>=", { desc = "Balance splits" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wH", "<C-w>H", { desc = "Move left" })
map("n", "<leader>wh", "<C-w>h", { desc = "Change left" })
map("n", "<leader>wJ", "<C-w>J", { desc = "Move down" })
map("n", "<leader>wj", "<C-w>j", { desc = "Change down" })
map("n", "<leader>wK", "<C-w>K", { desc = "Move up" })
map("n", "<leader>wk", "<C-w>k", { desc = "Change up" })
map("n", "<leader>wL", "<C-w>L", { desc = "Move right" })
map("n", "<leader>wl", "<C-w>l", { desc = "Change right" })
map("n", "<leader>wo", "<C-w>o", { desc = "Only window" })
map("n", "<leader>wq", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows <-" })
map("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows ->" })
map("n", "<leader>ws", ":split<CR>", { desc = "Horizontal split" })
map("n", "<leader>wt", ":tab split<CR>", { desc = "New tab w/ current buf" })
map("n", "<leader>wv", ":vsplit<CR>", { desc = "Veritcal split" })
map("n", "<leader>wW", "<C-w>W", { desc = "Other window <-" })
map("n", "<leader>ww", "<C-w>w", { desc = "Other window ->" })
