return {
  "mg979/vim-visual-multi",
  branch = "master",
  config = function()
    vim.cmd([[
        let g:VM_theme = 'nord'

        " Set in keymaps.lua
        let g:VM_leader = ';'

        let g:VM_maps = {}
        let g:VM_maps['Motion ;'] = ';;'
        let g:VM_maps['Add Cursor Down'] = '<C-j>'
        let g:VM_maps['Add Cursor Up'] = '<C-k>'

        let g:VM_mouse_mappings = 1

        let g:VM_Mono_hl   = 'DiffChange'
        let g:VM_Extend_hl = 'DiffAdd'
        let g:VM_Cursor_hl = 'Visual'
        let g:VM_Insert_hl = 'DiffChange'

        let g:VM_highlight_matches = 'underline'
      ]])
  end,
}
