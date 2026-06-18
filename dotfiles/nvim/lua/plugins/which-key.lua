vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")

wk.setup({
  preset = "helix",
  sort = { "alphanum" },
  -- sort = { "mod", "order", "group", "alphanum" },
  plugins = {
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
  },
})

-- Text-object from: dotfiles/nvim/lua/plugins/text-objects.lua
wk.add({
  mode = { "o", "x" },
  { "ag", desc = "entire file" },
  { "ig", desc = "entire file" },
}, { notify = false })
