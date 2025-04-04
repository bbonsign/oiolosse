-- silences warning when theme background is transparent
return {
  "rcarriga/nvim-notify",
  -- Managed by snacks.nvim now
  enabled = false,
  opts = {
    background_colour = "#000000",
  },
  keys = {
    {
      "<leader>tn",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all Notifications",
    },
    {
      "<leader><BS>",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all Notifications",
    },
  },
}
