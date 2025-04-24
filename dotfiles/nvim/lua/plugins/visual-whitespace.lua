return {
  "mcauley-penney/visual-whitespace.nvim",
  config = true,
  event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
  init = function()
    vim.api.nvim_set_hl(0, "VisualNonText", {
      fg = "#636DA6", -- Comment fg
      -- fg = "#444A73", -- BlinkGhiostText fg
      bg = "#2D3F76",
    })

    vim.keymap.set(
      { "n", "v" },
      "<leader>uv",
      require("visual-whitespace").toggle,
      { desc = "Toggle visual-whitespace" }
    )
  end,
  opts = {
    -- default to off, but toggle with keymap above
    enabled = false,
  },
}
