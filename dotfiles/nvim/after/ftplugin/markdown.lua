Snacks.toggle({
  name = "Render Markdown",
  get = function()
    return require("render-markdown.state").enabled
  end,
  set = function(enabled)
    local m = require("render-markdown")
    if enabled then
      m.enable()
    else
      m.disable()
    end
  end,
}):map("<leader>um")

vim.keymap.set("n", "<leader>uM", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })
