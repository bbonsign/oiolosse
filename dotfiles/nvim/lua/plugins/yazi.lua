Config.later(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
  })

  ---@type YaziConfig | {}
  local opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
    integrations = {
      grep_in_directory = "snacks.picker",
      grep_in_selected_files = "snacks.picker",
      picker_add_copy_relative_path_action = "snacks.picker",
    },
  }
  -- 👇 if you use `open_for_directories=true`, this is recommended
  -- mark netrw as loaded so it's not loaded at all.
  -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
  vim.g.loaded_netrwPlugin = 1

  require("yazi").setup(opts)

  vim.keymap.set({ "n", "v" }, "<leader>yy", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
  vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
  vim.keymap.set("n", "<leader>yw", "<cmd>Yazi cwd<cr>", { desc = "Open the file manager in nvim's working directory" })
  vim.keymap.set("n", "<leader>yr", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
end)
