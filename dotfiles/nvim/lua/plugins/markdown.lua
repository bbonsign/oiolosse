vim.pack.add({ "https://github.com/timantipov/md-table-tidy.nvim" })
require("md-table-tidy").setup({
  padding = 1, -- number of spaces for cell padding
  keymap = {
    table_tidy = "<localleader>tt", -- key for command :TableTidy<CR>
    table_tidy_all = "<localleader>ta", -- key for command :TableTidyAll<CR>
  },
})

vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-tree/nvim-web-devicons",
})
require("render-markdown").setup({
  anti_conceal = { enabled = false },
  pipe_table = {
    preset = "round",
    alignment_indicator = "┅",
  },
  heading = {
    width = "block",
    min_width = 30,
  },
  code = {
    sign = false,
    border = "thick",
    right_pad = 1,
    conceal_delimiters = false,
  },
})

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })
Config.on_packchanged("markdown-preview.nvim", { "install", "update" }, function()
  vim.fn["mkdp#util#install"]()
end, "Update markdown-preview")
