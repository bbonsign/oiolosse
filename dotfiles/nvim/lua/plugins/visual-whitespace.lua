Config.later(function()
  vim.pack.add({ "https://github.com/mcauley-penney/visual-whitespace.nvim" }, { load = false })

  -- configuring with lazy load on entering visual mode
  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*:[vV\22]",
    once = true,
    callback = function()
      vim.cmd.packadd("visual-whitespace.nvim")
      require("visual-whitespace").setup({
        -- default to off, but toggle with keymap above
        enabled = false,
      })
    end,
  })

  vim.api.nvim_set_hl(0, "VisualNonText", {
    fg = "#636DA6", -- Comment fg
    -- fg = "#444A73", -- BlinkGhiostText fg
    bg = "#2D3F76",
  })

  vim.keymap.set({ "n", "v" }, "<leader>uv", require("visual-whitespace").toggle, { desc = "Toggle visual-whitespace" })
end)
