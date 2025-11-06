return {
  {
    "folke/sidekick.nvim",
    enabled = false,
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.keymap.set(
        { "n", "v" },
        "<LocalLeader><C-a>",
        "<cmd>CodeCompanionActions<cr>",
        { noremap = true, silent = true }
      )
      vim.keymap.set(
        { "n", "v" },
        "<LocalLeader><C-c>",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { noremap = true, silent = true }
      )
      vim.keymap.set("v", "<LocalLeader>a", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cabbrev cc CodeCompanion]])
    end,
    opts = {
      display = {
        action_palette = { provider = "snacks" },
      },
      -- extensions = {
      --   mcphub = {
      --     -- callback = "mcphub.extensions.codecompanion",
      --     opts = {
      --       -- MCP Tools
      --       make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
      --       show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
      --       add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
      --       show_result_in_chat = true, -- Show tool results directly in chat buffer
      --       format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
      --       -- MCP Resources
      --       make_vars = true, -- Convert MCP resources to #variables for prompts
      --       -- MCP Prompts
      --       make_slash_commands = true, -- Add MCP prompts as /slash commands
      --     },
      --   },
      -- },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bun install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    -- config = function()
    --   require("mcphub").setup()
    -- end,
  },
}
