return {
  "Wansmer/treesj",
  keys = {
    "<space>M",
    "<space>J",
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
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
      max_join_length = 240,
      langs = langs,
    })

    vim.keymap.set("n", "<leader>J", require("treesj").toggle, { desc = "Treesj" })
    vim.keymap.set("n", "<leader>M", require("treesj").toggle, { desc = "Treesj" })
  end,
}
