local M = {}

M.setup = function()
  -- I switch ":" and ";", which messes up using ';' for the next "f search"
  -- Enter and Backspace are used in nvim/plug-config/sneak.vim
  -- so the f-versions have an 'f' prefix.  This allows for vim-sneak and the
  -- normal f & t searching to be used
  local function map(mode, keys, command)
    return vim.api.nvim_set_keymap(mode, keys, command, { noremap = true, silent = true })
  end

  map("n", "-", "<cmd>edit .<CR>")

  map("n", "F", "<cmd>HopPattern<CR>")
  map("n", "S", "<cmd>HopWordCurrentLineAC<CR>")

  -- map("n", "<CR>", ";")
  -- map("n", "<BS>", ",")

  -- highlight the visual selection after pressing enter.
  -- map("x", "<CR>",
  --   [[*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>]])

  -- Enter command window from noraml mode
  -- note: enter command window with Ctrl-F when already at cmd line
  map("n", "g:", "q:")
  map("v", "g:", "q:")
  map("n", "q:", "<nop>")
  map("v", "q:", "<nop>")

  -- avoid accidental number increment
  map("n", "<C-x>", "<nop>")

  -- Mostly to avoid annoying message about how to exit
  map("n", "<C-c>", "<nop>")

  -- Run macro in the "q register with Q, inc over a visual selection
  map("n", "Q", "@q")
  map("v", "Q", [[:norm @q<cr>]])

  -- quickfix conveniences
  -- "  nnoremap ] ,":cnext<cr>"
  -- map("n"noremap" [q :cprevious<cr>)

  -- Keep selected region when indenting repeatedly
  -- vnoremap > gv
  -- vnoremap < <gv

  -- Use Ctrl-s to increment number at cursor since we remap C-a below
  -- map("n", "<C-s>", "<C-a>")

  -- Let's write some λ's!!!
  map("i", [[<C-\>]], "λ")

  -- UndoTree
  map("n", "<leader>U", ":UndotreeToggle<CR>")

  -- shortcuts for ctrl-a and ctrl-e in insert/normalcommand mode
  map("i", "<C-e>", "<Esc>A")
  map("i", "<C-a>", "<Esc>I")
  map("n", "<C-e>", "$")
      map("n", "<C-a>", "^")
  map("v", "<C-e>", "g_")
  map("v", "<C-a>", "^")
  map("c", "<C-e>", "<End>")
  map("c", "<C-a>", "<Home>")

  map("i", "<C-u>", "<Esc>ld0i")
  map("i", "<C-w>", "<Esc>ldbi")

  -- Since ctrl-e is overwritten, use ctrl-h instead
  -- ctrl-e scrolls up a line, ctrl-y down a line
  map("n", "<C-h>", "<C-e>")
  map("v", "<C-h>", "<C-e>")

  -- Move by visual lines
  map("n", "j", "gj")
  map("n", "k", "gk")

  -- Use shift + arrows to resize windows
  map("n", "<A-Down>", [[:resize -2<CR>]])
  map("n", "<A-Up>", [[:resize +2<CR>]])
  map("n", "<A-Left>", [[:vertical resize -2<CR>]])
  map("n", "<A-Right>", [[:vertical resize +2<CR>]])

  -- vim.cmd [[
  --   " https://github.com/tpope/vim-surround/issues/269
  --   " Disable the default mappings (s, ys, S etc)
  --   let g:surround_no_mappings=1

  --   nmap ds  <Plug>Dsurround
  --   nmap cs  <Plug>Csurround
  --   nmap cS  <Plug>CSurround
  --   nmap s   <Plug>Ysurround
  --   nmap yS  <Plug>YSurround
  --   nmap ss  <Plug>Yssurround
  --   nmap ySs <Plug>YSsurround
  --   nmap ySS <Plug>YSsurround
  --   xmap s   <Plug>VSurround
  --   xmap gS  <Plug>VgSurround

  --   if !exists("g:surround_no_insert_mappings") || ! g:surround_no_insert_mappings
  --     if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
  --       imap    <C-S> <Plug>Isurround
  --     endif
  --     imap      <C-G>s <Plug>Isurround
  --     imap      <C-G>S <Plug>ISurround
  --   endif
  -- ]]

  -- Alt+{k,j} drag line up/down
  -- Already provided by LunarVim
  -- nnoremap <silent> <A-j> :m .+1<CR>==
  -- nnoremap <silent> <A-k> :m .-2<CR>==
  -- inoremap <silent> <A-j> <Esc>:m .+1<CR>==gi
  -- inoremap <silent> <A-k> <Esc>:m .-2<CR>==gi
  -- vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
  -- vnoremap <silent> <A-k> :m '<-2<CR>gv=gv


  -- Toggle comments in visual mode, from tpope/commentary plugin
  -- Note that C-_ actually maps to C-/, which is what I want
  -- https://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
  -- nnoremap <silent> <C-_> :Commentary<CR>
  -- vnoremap <silent> <C-_> :Commentary<CR>

  -- Use the blackhole register "_ by deiault for x
  map("n", "x", '"_x')
  map("v", "x", '"_x')
  -- nnoremap d "_d
  -- vnoremap d --_d
  -- nnoremap D "_D
  -- vnoremap D "_D
  -- nnoremap c "_c
  -- vnoremap c "_c
  -- nnoremap C "_C
  -- vnoremap C "_C

  -- Use <space> prefix for default behavior (deleted text -> default register)
  -- nnoremap <space>d d
  -- vnoremap <space>d d
  -- nnoremap <space>D D
  -- vnoremap <space>D D
  -- nnoremap <space>c c
  -- vnoremap <space>c c
  -- nnoremap <space>C C
  -- vnoremap <space>C C

  -- Center line when jumping to search results
  map("n", "n", "nzz")
  map("n", "N", "Nzz")

  -- Redefine default keybinds for line text object (the l conflicts with
  -- targets.vim)
  -- let g:textobj_line_no_default_key_mappings = 1
  -- omap i. <Plug>(textobj-line-i)
  -- omap a. <Plug>(textobj-line-a)
  -- xmap i. <Plug>(textobj-line-i)
  -- xmap a. <Plug>(textobj-line-a)

  -- let g:textobj_line_no_default_key_mappings = 1
  -- omap ig <Plug>(textobj-entire-i)
  -- omap ag <Plug>(textobj-entire-a)
  -- xmap ig <Plug>(textobj-entire-i)
  -- xmap ag <Plug>(textobj-entire-a)
end

return M
