return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  config = function()
    vim.cmd([[let g:tmux_navigator_no_mappings = 1]])
    vim.cmd([[let  g:tmux_navigator_no_wrap = 1]])
    vim.keymap.del("n", "<C-h>")
    vim.keymap.del("n", "<C-j>")
    vim.keymap.del("n", "<C-k>")
    vim.keymap.del("n", "<C-l>")
  end,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<A-h>", ":TmuxNavigateLeft<CR>", silent = true },
    { "<A-j>", ":TmuxNavigateDown<CR>", silent = true },
    { "<A-k>", ":TmuxNavigateUp<CR>", silent = true },
    { "<A-l>", ":TmuxNavigateRight<CR>", silent = true },
    -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
