return {
  {
    "Owen-Dechow/videre.nvim",
    cmd = "Videre",
    dependencies = {
      -- "Owen-Dechow/graph_view_yaml_parser", -- Optional: add YAML support
      -- "Owen-Dechow/graph_view_toml_parser", -- Optional: add TOML support
      -- "a-usr/xml2lua.nvim", -- Optional | Experimental: add XML support
    },
    keys = {
      { "<localleader><C-j>", "<Cmd>Videre<CR>" },
    },
    opts = {
      -- round_units = false,
      simple_statusline = true, -- If you are just starting out with Videre,
      --   setting this to `false` will give you
      --   descriptions of available keymaps.
    },
  },

  { "tpope/vim-unimpaired" },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>uu", "<Cmd>UndotreeToggle<CR>" },
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        options = {
          parsers = {
            css = true,
            css_fn = true,
            tailwind = { enable = true },
            hex = { enable = true },
          },
          -- display = {
          --   mode = "virtualtext",
          --   virtualtext = { position = "eol", hl_mode = "foreground" },
          -- },
        },
      })
    end,
  },

  {
    "tzachar/highlight-undo.nvim",
    opts = {
      hlgroup = "HighlightUndo",
      duration = 300,
      pattern = { "*" },
      ignored_filetypes = {
        "neo-tree",
        "fugitive",
        "TelescopePrompt",
        "mason",
        "lazy",
        "snacks_dashboard",
        "oil",
        "man",
      },
      --- Return true for buffers to disable undo-highlight on.
      ignore_cb = function(_buf_no)
        return not vim.o.modifiable or vim.o.ft == ""
      end,
    },
  },
}
