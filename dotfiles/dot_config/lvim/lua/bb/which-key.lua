local M = {}


M.setup = function()

  lvim.builtin.which_key.mappings[" "] = { "<cmd>Telescope git_files<CR>", "Git Files" }
  lvim.builtin.which_key.mappings["'"] = { "<cmd>Telescope resume<CR>", "Resume" }
  lvim.builtin.which_key.mappings["."] = { "<cmd>Telescope find_files<CR>", "Buffers" }
  lvim.builtin.which_key.mappings[","] = { "<cmd>Telescope buffers<CR>", "Buffers" }
  lvim.builtin.which_key.mappings[":"] = { "<cmd>Telescope commands<CR>", "Commands" }
  lvim.builtin.which_key.mappings["/"] = { "<cmd>Telescope<CR>", "Telescope" }
  lvim.builtin.which_key.mappings["y"] = { ":lua require('telescope').extensions.neoclip.default()<CR>", "neoclip" }
  lvim.builtin.which_key.mappings["m"] = {
    ":<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<CR><c-f><left>",
    "edit macro"
  }
  lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

  lvim.builtin.which_key.mappings["s"]["s"] = { "<cmd>Telescope<CR>", "Telescope" }
  lvim.builtin.which_key.mappings["s"]["b"] = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "FzyBuffer" }
  lvim.builtin.which_key.mappings["s"]["c"] = { "<cmd>Telescope commands<CR>", "Commands" }
  lvim.builtin.which_key.mappings["s"]["C"] = { "<cmd>Telescope colorschemes<CR>", "Colorschemes" }

  lvim.builtin.which_key.mappings["l"]["s"] = { "<cmd>SymbolsOutline<CR>", "SymbolsOutline" }

  lvim.builtin.which_key.mappings["<tab>"] = {
    name = "tabs",
    ["]"] = { "<cmd>tabnext<CR>", "Next" },
    ["["] = { "<cmd>tabprevious<CR>", "Previous" },
    ["<tab>"] = { ':tab split<CR>', 'new tab w/ current buf' },
    c = { "<cmd>tabclose<CR>", "Close" },
    d = { "<cmd>tabclose<CR>", "Close" },
    f = { "<cmd>tabfirst<CR>", "First" },
    l = { "<cmd>tablast<CR>", "Last" },
    n = { "<cmd>tabnext<CR>", "Next" },
    p = { "<cmd>tabprevious<CR>", "Prev" },
    t = { ':tab split<CR>', 'new tab w/ current buf' }
  }
  lvim.builtin.which_key.mappings["a"] = {
    name = '+actions',
    [':'] = { 'A;<Esc>', 'append ;' },
    a = { 'A_<Esc>r', 'append char to line' },
    C = { ':ColorizerToggle<CR>', 'toggle colorizer' },
    c = { ':set cursorline!<CR>', 'toggle line hi-light' },
    n = { ':set nonumber!<CR>', 'line-numbers' },
    r = { ':set norelativenumber!<CR>', 'relative line nums' },
    S = { ':let @/ = ""<CR>', 'remove search highlight' },
    s = { ':setlocal spell!<CR>', 'toggle spelling in buffer' },
    t = { ':FloatermToggle<CR>', 'terminal' },
    v = { ':SymbolsOutline<CR>', 'tag viewer' },
    -- v = { ':Vista!!<CR>', 'tag viewer' },
    -- v = {':TagbarToggle<CR>', 'tag viewer'},
    w = { ':set wrap!<CR>', 'toggle wrap' },
  }
  lvim.builtin.which_key.mappings["b"] = {
    name = '+buffer',
    b = { ':Telescope buffers<CR>', 'fzf-buffer' },
    D = { ':BufDel!<CR>', 'delete-buffer, ignore changes' },
    d = { ':BufDel<CR>', 'delete-buffer' },
    f = { ':bfirst<CR>', 'first-buffer' },
    k = { ':BufDel<CR>', 'delete-buffer' },
    l = { ':blast<CR>', 'last-buffer' },
    n = { ':bnext<CR>', 'next-buffer' },
    p = { ':bprevious<CR>', 'previous-buffer' }
  }

  lvim.builtin.which_key.mappings["f"] = {
    name = "+Files",
    f = { "<cmd>Telescope find_files<CR>", "Files" },
    b = { "<cmd>Telescope file_browser<CR>", "File Browser" },
    w = { "<cmd>w<CR>", "Write file" },
    R = { ":earlier 1f<CR>", "revert to last write" },
    s = { "<cmd>w<CR>", "Write file" },
  }
  lvim.builtin.which_key.mappings["s"]["d"] = { "<cmd>Telescope lsp_document_symbols<CR>", "document symbols" }
  lvim.builtin.which_key.mappings["s"]["w"] = { "<cmd>Telescope lsp_workspace_symbols<CR>", "workspace symbols" }
  lvim.builtin.which_key.mappings["n"] = {
    name = "notify",
    c = { "<cmd>lua require('notify').dismiss()<CR>", "dismiss" },
    d = { "<cmd>lua require('notify').dismiss()<CR>", "dismiss" },
    n = { "<cmd>lua require('notify').dismiss()<CR>", "dismiss" },
  }
  lvim.builtin.which_key.mappings["S"] = {
    name = "Session",
    c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
    l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
    Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
  }
  lvim.builtin.which_key.mappings["t"] = {
    name = "+Term",
    l = { ":ToggleTermSendCurrentLine<CR>", "Send line" },
    v = { ":ToggleTermSendVisualLines<CR>", "Send lines", mode = "v" },
    t = { ":ToggleTerm<CR>", "ToggleTerm" },
  }
  lvim.builtin.which_key.mappings["x"] = {
    name = "+Trouble",
    t = { "<cmd>TroubleToggle<cr>", "Toggle" },
    x = { "<cmd>TroubleToggle<cr>", "Toggle" },
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
  }
  lvim.builtin.which_key.mappings["w"] = {
    name = "+window",
    ["="] = { '<C-w>=', 'balance splits' },
    c = { '<C-w>c', 'close window' },
    H = { '<C-w>H', 'move left' },
    h = { '<C-w>h', 'change left' },
    J = { '<C-w>J', 'move down' },
    j = { '<C-w>j', 'change down' },
    K = { '<C-w>K', 'move up' },
    k = { '<C-w>k', 'change up' },
    L = { '<C-w>L', 'move right' },
    l = { '<C-w>l', 'change right' },
    m = { ':MaximizerToggle!<CR>', 'maximizer toggle' },
    o = { '<C-w>o', 'only window' },
    q = { '<C-w>c', 'close window' },
    R = { '<C-w>R', 'rotate windows <-' },
    r = { '<C-w>r', 'rotate windows ->' },
    s = { ':split<CR>', 'horizontal split' },
    t = { ':tab split<CR>', 'new tab w/ current buf' },
    v = { ':vsplit<CR>', 'veritcal split' },
    W = { '<C-w>W', 'other window <-' },
    w = { '<C-w>w', 'other window ->' },
    z = { ':MaximizerToggle!<CR>', 'maximizer toggle' }
  }
  lvim.builtin.which_key.mappings["h"] = {
    s = { '<cmd>Gitsigns stage_hunk<CR>', "desc" },
    r = { '<cmd>Gitsigns reset_hunk<CR>', "desc" },
    S = { '<cmd>Gitsigns stage_buffer<CR>', "desc" },
    u = { '<cmd>Gitsigns undo_stage_hunk<CR>', "desc" },
    R = { '<cmd>Gitsigns reset_buffer<CR>', "desc" },
    p = { '<cmd>Gitsigns preview_hunk<CR>', "desc" },
    B = { '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', "desc" },
    b = { '<cmd>Gitsigns toggle_current_line_blame<CR>', "desc" },
    d = { '<cmd>Gitsigns diffthis<CR>', "desc" },
    D = { '<cmd>lua require"gitsigns".diffthis("~")<CR>', "desc" },
    -- Text object
    -- map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    -- map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  }
end

return M
