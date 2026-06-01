-- https://www.lazyvim.org/configuration/recipes#change-surround-mappings
require("mini.ai").setup({
  custom_textobjects = {
    r = require("mini.ai").gen_spec.pair("[", "]"),
    c = require("mini.ai").gen_spec.pair("{", "}"),
  },
})

-- Config.later(function()
vim.pack.add({
  "https://github.com/kana/vim-textobj-user",
  -- Provides `div` etc to delete inside camelCase and other segemented "words"
  "https://github.com/Julian/vim-textobj-variable-segment",
  -- Provides motions for navigating "words" as in camelCase, skippping punctuation, etc
  "https://github.com/chrisgrieser/nvim-spider",
})
-- setup call is optional for spider
-- require("spider").setup({
--   -- -- defaults:
--   --   skipInsignificantPunctuation = true,
--   --   consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
--   --   subwordMovement = true,
--   --   customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
-- })
vim.keymap.set({ "n", "o", "x" }, "<A-w>", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set({ "n", "o", "x" }, "<A-e>", "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set({ "n", "o", "x" }, "<A-b>", "<cmd>lua require('spider').motion('b')<CR>")
-- end)
