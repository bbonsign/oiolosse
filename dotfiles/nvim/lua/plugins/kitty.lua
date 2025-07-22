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

  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },

  { -- syntax highlighting for kitty.conf
    "fladson/vim-kitty",
    ft = "kitty",
    -- tag = "*", -- You can select a tagged version
  },
}
