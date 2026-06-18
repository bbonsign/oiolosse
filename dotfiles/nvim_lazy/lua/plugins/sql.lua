return {
  "tpope/vim-dadbod",
  enabled = true,
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
  -- opts = {
  --   db_completion = function()
  --     require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
  --   end,
  -- },
  config = function(_, opts)
    -- vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

    -- Database connections
    vim.g.dbs = {
      local_postgres_postgres = "postgres://postgres@localhost:5432/postgres",
      duckdb_memory = "duckdb:",
      -- duckdb_file = "duckdb:///tmp/analytics.duckdb",
    }

    vim.g.db_ui_execute_on_save = 0 --do not execute on save
    vim.g.db_ui_win_position = "right"

    vim.g.vim_dadbod_completion_lowercase_keywords = 1
    vim.g.vim_dadbod_completion_disable_notifications = 1
    -- vim.g.db_ui_force_echo_notifications = 1
    -- vim.g.db_ui_disable_info_notifications = 1

    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = {
    --     "sql",
    --   },
    --   command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
    -- })

    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = {
    --     "sql",
    --     "mysql",
    --     "plsql",
    --   },
    --   callback = function()
    --     vim.schedule(opts.db_completion)
    --   end,
    -- })
  end,
  keys = {
    { "<leader>DD", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
    { "<leader>DT", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
    { "<leader>DF", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
    { "<leader>DR", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
    { "<leader>DQ", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
  },
}
