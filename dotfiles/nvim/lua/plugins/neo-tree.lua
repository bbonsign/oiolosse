return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      ":Neotree toggle float reveal<CR>",
      silent = true,
      desc = "Float File Explorer",
    },
    {
      "<leader><Tab>",
      ":Neotree toggle right<CR>",
      silent = true,
      desc = "Right File Explorer",
    },
    {
      "<leader>fS",
      function()
        require("neo-tree.command").execute({ source = "document_symbols", toggle = true })
      end,
      desc = "NeoTree Git status",
    },
    {
      "<leader>bt",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "NeoTree Git status",
    },
    {
      "<leader>gt",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "NeoTree Git status",
    },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,
    filesystem = {
      hijack_netrw_behavior = "disabled",
      window = {
        mappings = { ["-"] = "navigate_up" },
      },
    },
    sources = {
      "filesystem",
      "buffers",
      "git_status",
      "document_symbols",
    },
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem", display_name = "   Files " },
        { source = "buffers", display_name = "   Buffers " },
        { source = "git_status", display_name = "   Git Status " },
      },
    },
    window = {
      position = "float", -- "right"
      mappings = {
        ["L"] = "next_source",
        ["H"] = "prev_source",
        ["]"] = "next_source",
        ["["] = "prev_source",
        ["h"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        ["<Left>"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        ["l"] = "open",
        ["<Right>"] = "open",
        ["p"] = { "toggle_preview", config = { use_float = true } },
      },
    },
  },
}
