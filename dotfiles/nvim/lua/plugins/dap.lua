return {
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>dC",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
      {
        "<leader>dc",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").focus_frame()
        end,
        desc = "Goto frame",
      },
      {
        "<leader>dw",
        "<nop>",
        desc = "disabled",
      },
      {
        "<leader>dfb",
        function()
          require("dapui").float_element("breakpoints", { enter = true })
        end,
        desc = "Floating Breakpoints",
      },
      {
        "<leader>dff",
        function()
          require("dapui").float_element("stacks", { enter = true })
        end,
        desc = "Floating Stack Frames",
      },
      {
        "<leader>dfv",
        function()
          require("dapui").float_element("scopes", { enter = true })
        end,
        desc = "Floating Variable Scopes",
      },
    },
    opts = {
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
      },
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 60,
        },
        -- {
        --   elements = {
        --     {
        --       id = "repl",
        --       size = 0.5,
        --     },
        --     {
        --       id = "console",
        --       size = 0.5,
        --     },
        --   },
        --   position = "bottom",
        --   size = 10,
        -- },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    keys = {
      { "<leader>dv", "<cmd>DapVirtualTextToggle<cr>", desc = "Toggle Virtual Text" },
    },
    opts = {
      virt_text_pos = "eol",
    },
  },
}
