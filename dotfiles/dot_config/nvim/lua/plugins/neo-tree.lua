return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
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
    source_selector = { winbar = true },
    window = {
      position = "right",
      mappings = {
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
