local later = Config.later
local auto_format = true

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require("conform").setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = "fallback",
    },
    -- setting this enables format on save
    format_on_save = function(bufnr)
      local ignore_filetypes = { "sql", "yaml", "yml" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    formatters_by_ft = {
      sh = { "shfmt" },
      lua = { "stylua" },
      fish = { "fish_indent" },
      python = { "ruff_organize_imports", "ruff_format" },
      nu = { "topiary_nu" },
      toml = { "taplo", "injected" },
      -- -- You can customize some of the format options for the filetype (:help conform.format)
      -- rust = { "rustfmt", lsp_format = "fallback" },
      -- -- Conform will run the first available formatter
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
      topiary_nu = {
        command = "topiary",
        args = { "format", "--language", "nu" },
      },
    },
  })
end)

vim.api.nvim_create_user_command("FormatDisable", function(opts)
  if opts.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
  vim.notify("Autoformat disabled" .. (opts.bang and " (buffer)" or " (global)"), vim.log.levels.WARN)
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  vim.notify("Autoformat enabled", vim.log.levels.INFO)
end, { desc = "Re-enable autoformat-on-save" })

-- stylua: ignore start
vim.keymap.set(
  "n",
  "<leader>uf",
  function()
    auto_format = not auto_format
    if auto_format then
      vim.cmd("FormatEnable")
    else
      vim.cmd("FormatDisable")
    end
  end,
  { desc = "Toggle Autoformat" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>cn",
  "<cmd>ConformInfo<cr>",
  { desc = "Conform Info" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>cf",
  function()
    require("conform").format({ async = true }, function(err, did_edit)
      if not err and did_edit then
        vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
      end
    end)
  end,
  { desc = "Format buffer" }
)

vim.keymap.set({ "n", "v" },
  "<leader>lf",
  function()
    require("conform").format({ async = true }, function(err, did_edit)
      if not err and did_edit then
        vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
      end
    end)
  end,
  { desc = "Format buffer" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>cF",
  function()
    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
  end,
  { desc = "Format Injected Langs" }
)

vim.keymap.set(
  { "n", "v" },
  "<leader>lF",
  function()
    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
  end,
  { desc = "Format Injected Langs" }
)
