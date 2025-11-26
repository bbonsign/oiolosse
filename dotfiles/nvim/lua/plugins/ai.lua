return {
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },

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
    -- TODO: not loaded automatically yet
    config = function()
      -- Send a quick message to the agent
      vim.api.nvim_create_user_command("AmpSend", function(opts)
        local message = opts.args
        if message == "" then
          print("Please provide a message to send")
          return
        end

        local amp_message = require("amp.message")
        amp_message.send_message(message)
      end, {
        nargs = "*",
        desc = "Send a message to Amp",
      })

      -- Send entire buffer contents
      vim.api.nvim_create_user_command("AmpSendBuffer", function(opts)
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local content = table.concat(lines, "\n")

        local amp_message = require("amp.message")
        amp_message.send_message(content)
      end, {
        nargs = "?",
        desc = "Send current buffer contents to Amp",
      })

      -- Add selected text directly to prompt
      vim.api.nvim_create_user_command("AmpPromptSelection", function(opts)
        local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
        local text = table.concat(lines, "\n")

        local amp_message = require("amp.message")
        amp_message.send_to_prompt(text)
      end, {
        range = true,
        desc = "Add selected text to Amp prompt",
      })

      -- Add file+selection reference to prompt
      vim.api.nvim_create_user_command("AmpPromptRef", function(opts)
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == "" then
          print("Current buffer has no filename")
          return
        end

        local relative_path = vim.fn.fnamemodify(bufname, ":.")
        local ref = "@" .. relative_path
        if opts.line1 ~= opts.line2 then
          ref = ref .. "#L" .. opts.line1 .. "-" .. opts.line2
        elseif opts.line1 > 1 then
          ref = ref .. "#L" .. opts.line1
        end

        local amp_message = require("amp.message")
        amp_message.send_to_prompt(ref)
      end, {
        range = true,
        desc = "Add file reference (with selection) to Amp prompt",
      })
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    enabled = false,
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
