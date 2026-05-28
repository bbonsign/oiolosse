return {
  {
    "knubie/vim-kitty-navigator",
    build = "cp ./*.py ~/.config/kitty/",
    cmd = {
      "KittyNavigateUp",
      "KittyNavigateDown",
      "KittyNavigateLeft",
      "KittyNavigateRight",
    },
    init = function()
      vim.g.kitty_navigator_enable_stack_layout = 1
    end,
    config = function()
      vim.cmd([[let g:kitty_navigator_no_mappings = 1]])
      vim.keymap.del("n", "<C-h>")
      vim.keymap.del("n", "<C-j>")
      vim.keymap.del("n", "<C-k>")
      vim.keymap.del("n", "<C-l>")
      -- vim.keymap.set("n", "<A-h>", ":KittyNavigateLeft<CR>", { silent = true })
      -- vim.keymap.set("n", "<A-j>", ":KittyNavigateDown<CR>", { silent = true })
      -- vim.keymap.set("n", "<A-k>", ":KittyNavigateUp<CR>", { silent = true })
      -- vim.keymap.set("n", "<A-l>", ":KittyNavigateRight<CR>", { silent = true })
    end,
    keys = {
      { "<A-h>", ":KittyNavigateLeft<CR>", silent = true },
      { "<A-j>", ":KittyNavigateDown<CR>", silent = true },
      { "<A-k>", ":KittyNavigateUp<CR>", silent = true },
      { "<A-l>", ":KittyNavigateRight<CR>", silent = true },
    },
  },

  { -- syntax highlighting for kitty.conf
    "fladson/vim-kitty",
    ft = "kitty",
    -- tag = "*", -- You can select a tagged version
  },
}
