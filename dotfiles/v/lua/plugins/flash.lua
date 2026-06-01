Config.later(function()
  vim.pack.add({
    "https://github.com/folke/flash.nvim",
  })
  ---@type Flash.Config
  local opts = {
    label = {
      before = true,
      after = false,
      rainbow = { enabled = false, shade = 9 },
    },
    modes = {
      search = { enabled = false },
      char = {
        -- autohide = true,
        -- jump_labels = true,
      },
      treesitter = {
        label = { before = false, after = false },
      },
    },
    incremental = true,
    highlight = {
      groups = {
        label = "@markup.heading.5.markdown",
      },
    },
  }

  require("flash").setup(opts)

  -- stylua: ignore start
  -- Toggle flash in "/" searches (when "/" is active)
  vim.keymap.set(
    { "c" },
    "<c-s>",
    require("flash").toggle,
    { desc = "Toggle Flash Search" }
  )

  vim.keymap.set(
    { "n", "x", "o" },
    "gs",
    require("flash").jump,
    { desc = "Flash" }
  )

  vim.keymap.set(
    { "n", "x", "o" },
    "S",
    require("flash").jump,
    { desc = "Flash" }
  )

  vim.keymap.set(
    { "o", "x" },
    "R",
    require("flash").treesitter_search,
    { desc = "Treesitter Search" }
  )

  vim.keymap.set(
    "o",
    "r",
    require("flash").remote,
    { desc = "Remote Flash" }
  )

  -- {
  --   "gS",
  --   mode = { "n", "o", "x" },
  --   function()
  --     require("flash").treesitter()
  --   end,
  --   desc = "Flash Treesitter",
  -- },
  -- {
  --   "r",
  --   mode = "o",
  --   function()
  --     require("flash").remote()
  --   end,
  --   desc = "Remote Flash",
  -- },
  -- {
  --   "R",
  --   mode = { "o", "x" },
  --   function()
  --     require("flash").treesitter_search()
  --   end,
  --   desc = "Treesitter Search",
  -- },
end)
