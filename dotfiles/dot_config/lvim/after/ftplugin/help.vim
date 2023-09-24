" From: https://vim.fandom.com/wiki/Learn_to_use_help

" Press Enter to jump to the subject (topic) under the cursor.
nnoremap <buffer> <CR> <C-]>

" Press Backspace to return from the last jump.
nnoremap <buffer> <BS> <C-T>

" Find links
" Press o to find the next option, or O to find the previous option.
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>
" Press <tab> to find the next subject, or <shift-tab> to find the previous subject.
nnoremap <buffer> <TAB> /\|\zs\S\+\ze\|<CR>:nohlsearch<CR>
nnoremap <buffer> <S-TAB> ?\|\zs\S\+\ze\|<CR>:nohlsearch<CR>
