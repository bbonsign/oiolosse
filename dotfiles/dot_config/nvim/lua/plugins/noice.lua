return {
  "folke/noice.nvim",
  presets = {
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },

  opts = {
    lsp = {
      -- https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua
      hover = {
        silent = true,
        opts = {
          border = {
            -- padding = { 0, 1 },
            style = "rounded",
          },
          position = { row = 2, col = 5 },
        },
      },

      signature = {
        opts = {
          position = { row = 2, col = 0 },
        },
      },

      documentation = {
        opts = {
          border = {
            -- padding = { 0, 0 },
            style = "rounded",
          },
        },
      },
    },
  },
}
