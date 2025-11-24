return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {
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
  },
  keys = {
    -- Toggle flash in "/" searches (when "/" is active)
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
    {
      "s",
      mode = { "n", "x", "o" },
      false,
    },
    {
      "gs",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
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
  },
}
