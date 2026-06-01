-- stylua: ignore start
vim.api.nvim_create_user_command(
  "TermHl",
  function()
    vim.api.nvim_open_term(0, {})
  end,
  {desc = "Highlights ANSI termcodes in curbuf"}
)

-- vim.api.nvim_create_user_command(
--   "PackInfo",
--   vim.pack.get,
--   {desc = "List Packages"}
-- )

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command
  end,
})
