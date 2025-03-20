local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

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
      "nvim-telescope/telescope-dap.nvim",
      config = function()
        require("telescope").load_extension("dap")
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
    -- { "<Leader>.", ":Telescope buffers<CR>", desc = "Buffers" },
    -- {
    --   "<leader>:",
    --   ":Telescope commands<CR>",
    --   desc = "Telescope commands",
    -- },
    -- {
    --   "<leader>/",
    --   function()
    --     require("telescope.builtin").live_grep()
    --   end,
    --   desc = "Live Grep",
    -- },
    -- {
    --   "<leader>sg",
    --   function()
    --     require("telescope.builtin").live_grep()
    --   end,
    --   desc = "Live Grep",
    -- },
    -- add a keymap to browse plugin files
    -- {
    --   "<leader>sP",
    --   function()
    --     require("telescope.builtin").find_files({
    --       cwd = require("lazy.core.config").options.root,
    --     })
    --   end,
    --   desc = "find plugin file",
    -- },
    -- {
    --   "<leader>s/",
    --   ":Telescope<CR>",
    --   desc = "Telescope",
    -- },
    -- {
    --   "<leader>'",
    --   ":Telescope resume<CR>",
    --   desc = "Telescope resume",
    -- },
    -- {
    --   '<leader>"',
    --   ":Telescope registers<CR>",
    --   desc = "Telescope",
    -- },
    -- {
    --   "<leader>g/",
    --   ":Telescope git_status<CR>",
    --   desc = "Telescope git_status",
    -- },
    -- {
    --   "<leader>gc",
    --   ":Telescope git_bcommits<CR>",
    --   desc = "Telescope Buffer Commits",
    -- },
    -- {
    --   "<leader>gf",
    --   ":Telescope git_files<CR>",
    --   desc = "Telescope git_files",
    -- },
    -- {
    --   "<leader>.",
    --   ":Telescope buffers<CR>",
    --   desc = "Telescope buffers",
    -- },
    {
      "<leader>d/b",
      ":Telescope dap list_breakpoints<CR>",
      desc = "Telescope breakpoints",
    },
    {
      "<leader>d/v",
      ":Telescope dap variables<CR>",
      desc = "Telescope variables",
    },
    {
      "<leader>d/f",
      ":Telescope dap frames<CR>",
      desc = "Telescope frames",
    },
    {
      "<leader>d/:",
      ":Telescope dap commands<CR>",
      desc = "Telescope dap commands",
    },
  },

  opts = {
    defaults = {
      winblend = 5,
      path_display = { truncate = true },
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
          ["<C-space>"] = action_layout.toggle_preview,
        },
      },
      n = {
        ["<C-j>"] = function(...)
          return actions.move_selection_next(...)
        end,
        ["<C-k>"] = function(...)
          return actions.move_selection_previous(...)
        end,
        ["<C-space>"] = action_layout.toggle_preview,
      },
    },
    pickers = {
      autocommands = { theme = "ivy" },
      buffers = { theme = "ivy" },
      builtin = { theme = "ivy" },
      colorscheme = { theme = "ivy" },
      command_history = { theme = "ivy" },
      commands = { theme = "ivy" },
      current_buffer_fuzzy_find = { theme = "ivy" },
      current_buffer_tags = { theme = "ivy" },
      diagnostics = { theme = "ivy" },
      fd = { theme = "ivy" },
      filetypes = { theme = "ivy" },
      find_files = { theme = "ivy" },
      git_bcommits = { theme = "ivy" },
      git_bcommits_range = { theme = "ivy" },
      git_branches = { theme = "ivy" },
      git_commits = { theme = "ivy" },
      git_files = { theme = "ivy" },
      git_stash = { theme = "ivy" },
      git_status = { theme = "ivy" },
      grep_string = { theme = "ivy" },
      help_tags = { theme = "ivy" },
      highlights = { theme = "ivy" },
      jumplist = { theme = "ivy" },
      keymaps = { theme = "ivy" },
      live_grep = {
        theme = "ivy",
        mappings = {
          i = {
            ["<C-f>"] = actions.to_fuzzy_refine,
            ["<C-space>"] = action_layout.toggle_preview,
          },
          n = {
            ["<C-f>"] = actions.to_fuzzy_refine,
            ["<C-space>"] = action_layout.toggle_preview,
          },
        },
      },
      loclist = { theme = "ivy" },
      lsp_definitions = { theme = "ivy" },
      lsp_document_symbols = { theme = "ivy" },
      lsp_dynamic_workspace_symbols = {
        theme = "ivy",
        mappings = {
          i = {
            ["<C-f>"] = actions.to_fuzzy_refine,
            ["<C-space>"] = action_layout.toggle_preview,
          },
          n = {
            ["<C-f>"] = actions.to_fuzzy_refine,
            ["<C-space>"] = action_layout.toggle_preview,
          },
        },
      },
      lsp_implementations = { theme = "ivy" },
      lsp_incoming_calls = { theme = "ivy" },
      lsp_outgoing_calls = { theme = "ivy" },
      lsp_references = {
        theme = "ivy",
        show_line = false,
      },
      lsp_type_definitions = { theme = "ivy" },
      lsp_workspace_symbols = { theme = "ivy" },
      man_pages = { theme = "ivy" },
      marks = { theme = "ivy" },
      oldfiles = { theme = "ivy" },
      pickers = { theme = "ivy" },
      planets = { theme = "ivy" },
      quickfix = { theme = "ivy" },
      quickfixhistory = { theme = "ivy" },
      registers = { theme = "ivy" },
      reloader = { theme = "ivy" },
      resume = { theme = "ivy" },
      search_history = { theme = "ivy" },
      spell_suggest = { theme = "ivy" },
      symbols = { theme = "ivy" },
      tags = { theme = "ivy" },
      tagstack = { theme = "ivy" },
      treesitter = { theme = "ivy" },
      vim_options = { theme = "ivy" },
    },
  },
}
