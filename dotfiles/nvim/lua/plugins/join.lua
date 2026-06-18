Config.later(function()
  vim.pack.add({
    "https://github.com/Wansmer/treesj",
    "https://github.com/nvim-treesitter/nvim-treesitter",
  })

  local langs = {
    python = {
      argument_list = {
        split = {
          last_separator = true,
        },
      },
      parameters = {
        split = {
          last_separator = true,
        },
      },
    },
  }

  require("treesj").setup({
    use_default_keymaps = false,
    max_join_length = 350,
    langs = langs,
  })

  vim.keymap.set("n", "<leader>J", require("treesj").toggle, { desc = "Treesj" })
  vim.keymap.set("n", "<leader>M", require("treesj").toggle, { desc = "Treesj" })
end)
