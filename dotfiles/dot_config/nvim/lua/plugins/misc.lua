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
}
