local M = {}

M.setup = function()
  vim.wo.number = false
  vim.opt.showtabline = 0
  vim.o.ttimeoutlen = 0
  vim.o.timeoutlen = 300
  -- Disable cursor movement wrapping overline
  vim.o.whichwrap = "b,s"

  -- Enable searching as you type, rather than waiting till you press enter.
  -- set incsearch
  -- Alternative found here <https://github.com/romainl/vim-cool/issues/9>
  -- which turns of search highlight after non-search keys (i.e. not *,n,N,/,?)

  vim.cmd [[
    noremap <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
    noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]

    fu! HlSearch()
        let s:pos = match(getline('.'), @/, col('.') - 1) + 1
        if s:pos != col('.')
            call StopHL()
        endif
    endfu

    fu! StopHL()
        if !v:hlsearch || mode() isnot 'n'
            return
        else
            sil call feedkeys("\<Plug>(StopHL)", 'm')
        endif
    endfu

    augroup SearchHighlight
    au!
        au CursorMoved * call HlSearch()
        au InsertEnter * call StopHL()
    augroup end
  ]]
end

return M
