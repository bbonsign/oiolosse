return {

  { "tpope/vim-unimpaired" },

  { "mbbill/undotree" },

  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          tailwind = true,
          -- mode = "virtualtext",
          -- virtualtext = "■",
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
