-- https:/ewww.lazyvim.org/configuration/recipes#change-surround-mappings

-- Whole-buffer text object (`ig`/`ag`). Taken from MiniExtra.gen_ai_spec.buffer.
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

require("mini.ai").setup({
  custom_textobjects = {
    r = require("mini.ai").gen_spec.pair("[", "]"),
    c = require("mini.ai").gen_spec.pair("{", "}"),
    g = ai_buffer, -- buffer
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
