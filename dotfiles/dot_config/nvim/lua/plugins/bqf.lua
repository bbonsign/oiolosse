return {
  "kevinhwang91/nvim-bqf",
  name = "bqf",
  event = { "BufRead", "BufNew" },
  keys = {
    {
      "<C-q>",
      ":call QuickFixToggle()<CR>",
      desc = "QuickFix Toggle",
      silent = true,
    },
  },
  opts = {
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
  },
  config = function(_bqf, opts)
    vim.cmd([[
      function! QuickFixToggle()
        if empty(filter(getwininfo(), 'v:val.quickfix'))
          copen
        else
          cclose
        endif
      endfunction
    ]])

    require("bqf").setup(opts)
  end,
}
