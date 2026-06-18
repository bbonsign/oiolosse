vim.pack.add({ "https://github.com/lukas-reineke/virt-column.nvim" })

require("virt-column").setup({
  -- highlight = "Comment",
  exclude = {
    filetypes = { "oil" },
  },
})
