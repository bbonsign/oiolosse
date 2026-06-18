Config.later(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/quicker.nvim" },
    { src = "https://github.com/kevinhwang91/nvim-bqf", name = "bqf" },
  })

  require("quicker").setup({
    edit = { enabled = false },
  })

  require("quicker").setup({
    auto_enable = true,
    preview = {
      winblend = 5,
      win_height = 12,
      win_vheight = 12,
      delay_syntax = 80,
      border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
    },
    func_map = {
      -- vsplit = "",
      -- ptogglemode = "z,",
      -- stoggleup = "",
    },
  })

  require("bqf").setup({
    auto_enable = true,
    preview = {
      winblend = 5,
      win_height = 12,
      win_vheight = 12,
      delay_syntax = 80,
      border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
    },
    func_map = {
      -- vsplit = "",
      -- ptogglemode = "z,",
      -- stoggleup = "",
    },
  })

  vim.cmd([[
      function! QuickFixToggle()
        if empty(filter(getwininfo(), 'v:val.quickfix'))
          copen
        else
          cclose
        endif
      endfunction
    ]])

  vim.keymap.set("n", "<C-q>", ":call QuickFixToggle()<CR>", { desc = "QuickFix Toggle", silent = true })
end)
