local actions = require("telescope.actions")

return {
  "telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "benfowler/telescope-luasnip.nvim",
      config = function()
        require("telescope").load_extension("luasnip")
      end,
    },
  },
  keys = {
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live Grep",
    },
    -- add a keymap to browse plugin files
    {
      "<leader>sP",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "find plugin file",
    },
    {
      "<leader>s/",
      ":Telescope<CR>",
      desc = "Telescope",
    },
    {
      "<leader>'",
      ":Telescope resume<CR>",
      desc = "Telescope resume",
    },
    {
      "<leader>g/",
      ":Telescope git_status<CR>",
      desc = "Telescope git_status",
    },
    {
      "<leader>gf",
      ":Telescope git_files<CR>",
      desc = "Telescope git_files",
    },
  },

  opts = {
    defaults = {
      winblend = 5,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      mappings = {
        i = {
          ["<C-j>"] = function(...)
            return actions.move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return actions.move_selection_previous(...)
          end,
        },
      },
      n = {
        ["<C-j>"] = function(...)
          return actions.move_selection_next(...)
        end,
        ["<C-k>"] = function(...)
          return actions.move_selection_previous(...)
        end,
      },
    },
    pickers = {
      lsp_references = {
        show_line = false,
      },
    },
  },
}
