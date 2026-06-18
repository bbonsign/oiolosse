local now_if_args = Config.now_if_args

vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  -- NOTE: mason-lspconfig automatically enables servers installed via mason
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup()

now_if_args(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvimtools/none-ls.nvim",
  })
  require("plugins.outline")

  local null_ls = require("null-ls")
  null_ls.setup({
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
    sources = {
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.completion.spell,
      null_ls.builtins.diagnostics.credo,
    },
  })

  -- NOTE: mason-lspconfig automatically enables servers installed via mason
  -- Use `:h vim.lsp.enable()` to automatically enable language server based on
  -- the rules provided by 'nvim-lspconfig'.
  -- Use `:h vim.lsp.config()` or 'after/lsp/' directory to configure servers.
  -- Uncomment and tweak the following `vim.lsp.enable()` call to enable servers.
  -- vim.lsp.enable({
  --   -- For example, if `lua-language-server` is installed, use `'lua_ls'` entry
  --   "lua_ls",
  --   "pyright",
  --   "ty",
  --   "ruff",
  --   "yamlls",
  -- })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(ev)
      local opts = { buffer = ev.buf }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Definition" }))
      -- vim.keymap.set("n", "<leader>lf", format, vim.tbl_extend("force", opts, { desc = "Format Document" }))
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
      vim.keymap.set(
        { "n", "v" },
        "<leader>la",
        vim.lsp.buf.code_action,
        vim.tbl_extend("force", opts, { desc = "code action" })
      )
      vim.keymap.set("n", "<leader>lA", function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end, vim.tbl_extend("force", opts, { desc = "Source Action" }))
      vim.keymap.set(
        { "n", "v" },
        "<leader>lI",
        "<cmd>checkhealth lsp",
        vim.tbl_extend("force", opts, { desc = "LSP Health" })
      )
      vim.keymap.set({ "n", "v" }, "<leader>li", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, vim.tbl_extend("force", opts, { desc = "Toggle Inlay Hints" }))
      vim.keymap.set("n", "<leader>hh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set("n", "<leader>ck", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set(
        "n",
        "<leader>lI",
        "<Cmd>checkhealth vim.lsp<CR>",
        vim.tbl_extend("force", opts, { desc = "Lsp Info" })
      )
      vim.keymap.set("n", "<leader>lm", "<Cmd>Mason<CR>", vim.tbl_extend("force", opts, { desc = "Mason" }))
      vim.keymap.set("n", "<leader>lS", "<Cmd>lsp stop<CR>", vim.tbl_extend("force", opts, { desc = "Lsp Stop" }))
      vim.keymap.set("n", "<leader>lR", "<Cmd>lsp restart<CR>", vim.tbl_extend("force", opts, { desc = "Lsp Restart" }))
    end,
  })
end)
