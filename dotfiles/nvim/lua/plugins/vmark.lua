return {
  "jake-stewart/vmark.nvim",
  event = "BufRead",
  config = function()
    local vmark = require("vmark")

    vmark.setup({
      format = function(details)
        -- see `:h nvim_buf_set_extmark()` for configuration options
        return {
          virt_text = { { " ◼ " .. details.text .. " ", "DiagnosticInfo" } },
          hl_mode = "combine",
          virt_text_pos = "eol",
          sign_hl_group = "DiagnosticInfo",
          sign_text = ">>",
        }
      end,
    })

    -- create a new vmark at the cursor position
    vim.keymap.set("n", "<Leader>ma", vmark.create)

    -- delete the vmark at the cursor position
    vim.keymap.set("n", "<Leader>md", vmark.removeUnderCursor)

    -- open the quickfix with all marks found recursively from current directory
    vim.keymap.set("n", "<Leader>mo", vmark.recursiveQuickfix)

    -- print the vmark text at the cursor position
    vim.keymap.set("n", "<Leader>me", vmark.echoUnderCursor)

    -- jump to the next/prev vmark in the document
    vim.keymap.set({ "n", "v", "o" }, "<Leader>mk", vmark.prev)
    vim.keymap.set({ "n", "v", "o" }, "<Leader>mj", vmark.next)
  end,
}
