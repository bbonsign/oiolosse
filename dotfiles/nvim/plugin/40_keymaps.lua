-- stylua: ignore start
vim.keymap.set("n", "<M-q>", "<cmd>qa<CR>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>R", MiniSessions.restart, { desc = "Mini restart" })
vim.keymap.set("n", "<leader>qr", MiniSessions.restart, { desc = "Mini restart" })

vim.keymap.set("n", "<leader>PU", vim.pack.update, {desc = "Update Plugins"})
vim.keymap.set("n", "<leader>PP", vim.pack.get, {desc = "Get Plugin Info"})

vim.keymap.set({ "o", "x" }, "am", "aW")
vim.keymap.set({ "o", "x" }, "im", "iW")

-- Clear search and stop snippet on escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- better indenting
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Use the blackhole register "_ by default for x
vim.keymap.set({ "n", "v" }, "x", '"_x')

-- To complement the default <C-y> for scrolling text up/down
-- with out moving cursor
vim.keymap.set("n", "<C-h>", "<C-e>")
-- vim.keymap.set("n", "<C-j>", "<C-e>")
-- vim.keymap.set("n", "<C-k>", "<C-y>")

vim.keymap.set(
  { "n", "v" },
  "<leader>p",
  '"0p',
  { desc = "Paste last yank" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>P",
  '"0P',
  { desc = "Paste last yank" }
)

-- Linewise put with reindent (adapted from vim-unimpaired)
local put = require("bb.put")
vim.keymap.set("n", "[p", put.above, { desc = "Put above (reindent)" })
vim.keymap.set("n", "]p", put.below, { desc = "Put below (reindent)" })
vim.keymap.set("n", "[P", put.above, { desc = "Put above (reindent)" })
vim.keymap.set("n", "]P", put.below, { desc = "Put below (reindent)" })
vim.keymap.set("n", ">P", put.above_rightward, { desc = "Put above and shift right" })
vim.keymap.set("n", ">p", put.below_rightward, { desc = "Put below and shift right" })
vim.keymap.set("n", "<P", put.above_leftward, { desc = "Put above and shift left" })
vim.keymap.set("n", "<p", put.below_leftward, { desc = "Put below and shift left" })
vim.keymap.set("n", "=P", put.above_reformat, { desc = "Put above and reformat" })
vim.keymap.set("n", "=p", put.below_reformat, { desc = "Put below and reformat" })

-- Option toggling (adapted from vim-unimpaired): [o enable, ]o disable, yo toggle
local toggle = require("bb.toggle")
for _, letter in ipairs(toggle.letters) do
  local name = toggle.name(letter)
  vim.keymap.set("n", "]o" .. letter, function() toggle.enable(letter) end, { desc = "Enable " .. name })
  vim.keymap.set("n", "[o" .. letter, function() toggle.disable(letter) end, { desc = "Disable " .. name })
  vim.keymap.set("n", "yo" .. letter, function() toggle.toggle(letter) end, { desc = "Toggle " .. name })
end

vim.keymap.set("n", "g==", ":.lua<CR>", { desc = "Lua eval" })
vim.keymap.set("v", "g=", ":'<,'>lua<CR>", { desc = "Lua eval" })

-- Center line when jumping to search results
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
-- search the visual selection
vim.keymap.set("x", "<CR>", '""y/<C-r>"<CR>N', { desc = "Search word under cursor" })
vim.keymap.set("n", "<CR>", "*N", { desc = "Search word under cursor" })

vim.keymap.set({ "n", "v" }, "g.", "g`.", { desc = "Goto last edit" })

-- Q replays last recorded register by default now
-- vim.keymap.set("n", "Q", "@q", { desc = 'Macro in "q' })
-- vim.keymap.set("v", "Q", [[:norm @q<CR>]], { desc = 'Macro in "q' })

vim.keymap.set("i", [[<C-\>]], "λ", { desc = "Insert λ characer" })
-- vim.keymap.set("i", [[<C-j>]], "|>", { desc = "|> Pipe" })

vim.keymap.set(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down", expr = true, silent = true }
)
vim.keymap.set(
  { "n", "x" },
  "<Down>",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down", expr = true, silent = true }
)
vim.keymap.set(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up", expr = true, silent = true }
)
vim.keymap.set(
  { "n", "x" },
  "<Up>",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up", expr = true, silent = true }
)

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
vim.keymap.set("c", "<C-p>", "<Up>", { desc = "Prev" })
vim.keymap.set("c", "<C-n>", "<Up>", { desc = "Next" })

-- https://nanotipsforvim.prose.sh/motion-setup--hjkl-as-amplified-hjkl
-- HJKL as amplified versions of hjkl
-- vim.keymap.set("n", "J", "6j")
-- vim.keymap.set("n", "K", "6k")
vim.keymap.set({ "n", "v" }, "H", "0^")
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set("n", "M", "J") -- mnemonic: [M]erge
vim.keymap.set("n", "<leader>hh", "K") -- mnemonic: [h]over

vim.keymap.set(
  "n",
  "<localleader>w",
  [[:%s/\s\+$//e<CR>]],
  { desc = "Trim trailing whitespace" }
)
vim.keymap.set(
  "n",
  "<leader>a:",
  "A;<Esc>",
  { desc = "Append ; to line" }
)

vim.keymap.set(
  "n",
  "<leader><space>",
  function() Snacks.picker("files") end,
  { desc = "Files" }
)
vim.keymap.set(
  "n",
  "<leader>,",
  function() Snacks.picker("buffers") end,
  { desc = "Buffers" }
)
vim.keymap.set(
  "n",
  "<leader>s/",
  function() Snacks.picker() end,
  { desc = "Pickers" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>lI",
  "<cmd>checkhealth lsp<CR>",
  { desc = "LSP Health" }
)

vim.keymap.set("n", "<leader>fs", ":w<CR>", { desc = "Write file" })
vim.keymap.set("n", "<leader>fw", ":w<CR>", { desc = "Write file" })
vim.keymap.set("n", "<leader>fR", ":earlier 1f<CR>", { desc = "Revert to last write" })
vim.keymap.set(
  "n",
  "<leader>ft",
  function()
    -- print(vim.bo.filetype) -- alternate option
    vim.notify("filetype: " .. vim.bo.filetype)
  end,
  { desc = "Notify filetype" }
)

vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Balance splits" })
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<leader>wf", "<Cmd>fc<CR>", { desc = "Close floating windows" })
vim.keymap.set("n", "<leader>wH", "<C-w>H", { desc = "Move left" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Change left" })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { desc = "Move down" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Change down" })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { desc = "Move up" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Change up" })
vim.keymap.set("n", "<leader>wL", "<C-w>L", { desc = "Move right" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Change right" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Only window" })
vim.keymap.set("n", "<leader>wq", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows <-" })
vim.keymap.set("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows ->" })
vim.keymap.set("n", "<leader>ws", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>w-", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>wt", ":tab split<CR>", { desc = "New tab w/ current buf" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Veritcal split" })
vim.keymap.set("n", "<leader>w|", ":vsplit<CR>", { desc = "Veritcal split" })
vim.keymap.set("n", "<leader>|", ":vsplit<CR>", { desc = "Veritcal split" })
vim.keymap.set("n", "<leader>wW", "<C-w>W", { desc = "Other window <-" })
vim.keymap.set("n", "<leader>ww", "<C-w>w", { desc = "Other window ->" })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

vim.keymap.set(
  "n",
  "<leader>gj",
  function() Snacks.terminal.toggle("jjui") end,
  { desc = "jjui" }
)

vim.keymap.set(
  "n",
  "<leader>fY",
  function()
    local filepath = vim.fn.expand("%:p")
    vim.fn.setreg("+", filepath)
    vim.notify("Copied: " .. filepath, vim.log.levels.INFO)
  end,
  {
    noremap = true,
    silent = true,
    desc = "Yank absolute file path",
  }
)

vim.keymap.set(
  "n",
  "<leader>fy",
  function()
    local filepath = vim.fn.expand("%:p")
    local root = vim.fn.getcwd()
    local relative = filepath:sub(#root + 2)
    vim.fn.setreg("+", relative)
    vim.notify("Copied: " .. relative, vim.log.levels.INFO)
  end,
  { noremap = true, silent = true, desc = "Yank relative file path" }
)

-- toggle options
-- vim.keymap.set("n", "<leader>uc", ":set cursorline!<CR>", { desc = "Toggle cursorline" })
Snacks.toggle.option("cursorline", { name = "Cursorline", global = true }):map("<leader>uc")

Snacks.toggle
  .option(
    "showtabline",
    {
      off = 0,
      on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
      name = "Tabline",
      global = true,
    }
  )
  :map("<leader>ut")
Snacks.toggle
  .option(
    "showtabline",
    {
      off = 0,
      on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
      name = "Tabline",
      global = true,
    }
  )
  :map("<leader>u<Tab>")

vim.keymap.set(
  "n",
  "<leader>uS",
  function()
    if vim.o.laststatus == 3 then
      vim.o.laststatus = 0
    else vim.o.laststatus = 3 end
  end,
  { desc = "Toggle Statusline" }
)

-- location list
vim.keymap.set(
  "n",
  "<leader>xl",
  function()
    local success, err = pcall(
      vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen
    )
    if not success and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
  { desc = "Location List" }
)

-- quickfix list
vim.keymap.set(
  "n",
  "<leader>xq",
  function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
  { desc = "Quickfix List" }
)

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" }) -- builtin
-- vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" }) -- builtin

-- highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set(
  "n",
  "<leader>uI",
  function()
    vim.treesitter.inspect_tree()
    vim.api.nvim_input("I")
  end,
  { desc = "Inspect Tree" }
)

-- z is for 'Fold level'. `<Leader>z<N>` sets 'foldlevel' to N (0-9).
for level = 0, 9 do
  vim.keymap.set(
    "n",
    '<leader>z' .. level,
    '<Cmd>set foldlevel=' .. level .. '<CR>',
    {desc = 'Fold level ' .. level}
  )
end

vim.keymap.set(
  "n",
  "<leader>zl",
  function()
    -- print(vim.bo.filetype) -- alternate option
    vim.notify("foldlevel: " .. vim.o.foldlevel)
  end,
  { desc = "Notify foldlevel" }
)

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- rename the current tab (uses lualine's :LualineRenameTab)
vim.keymap.set(
  "n",
  "<leader><tab>r",
  function()
    vim.ui.input(
      { prompt = "Tab name: " },
      function(name)
        if name then
          vim.cmd("LualineRenameTab " .. name)
        end
      end
    )
  end,
  { desc = "Rename Tab" }
)

-- tabs picker
vim.keymap.set(
  "n",
  "<leader><tab><tab>",
  function()
    Snacks.picker.pick("tabs")
  end,
  { desc = "Tabs Picker" }
)

-- go to tab by number
for i = 1, 9 do
  vim.keymap.set(
    "n",
    "<leader><tab>" .. i,
    "<cmd>" .. i .. "tabnext<cr>",
    { desc = "Go to Tab " .. i }
  )
end

-- lua
vim.keymap.set(
  { "n", "x" },
  "<localleader>r",
  Snacks.debug.run,
  { desc = "Run Lua" }
)

vim.keymap.set(
  "n",
  "gl",
  require("bb.utils").switch_case,
  {
    noremap = true,
    silent = true,
    desc = "Camel<->Snake",
  }
)

-- Abbrs
vim.cmd([[cabbr Wa wa]])
vim.cmd([[cabbr Wq wq]])
vim.cmd([[cabbr lau lua]])
