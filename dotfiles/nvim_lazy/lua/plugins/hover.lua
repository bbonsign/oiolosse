return {
  "lewis6991/hover.nvim",
  enabled = false,
  config = function()
    require("hover").setup({
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        -- require('hover.providers.gh')
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        require("hover.providers.dap")
        require("hover.providers.fold_preview")
        require("hover.providers.diagnostic")
        require("hover.providers.man")
        require("hover.providers.dictionary")
      end,
      preview_opts = {
        border = "single",
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 500,
    })
  end,
  -- About double tapping 'K' for entering hover window
  -- https://github.com/lewis6991/hover.nvim/issues/49#issuecomment-2073860825
  dependencies = {
    -- Override 'K' and 'gK' bindings from lazyvim's lspconfig
    {
      "neovim/nvim-lspconfig",
      -- https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps
      opts = function()
        local keys = require("lazyvim.plugins.lsp.keymaps").get()
        local hover = require("hover")
        keys[#keys + 1] = {
          "K",
          hover.hover,
          desc = "hover.nvim",
        }
        keys[#keys + 1] = {
          "gK",
          hover.hover_select,
          desc = "hover.nvim",
        }
      end,
    },
  },
}
