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
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Definition" })
      -- vim.keymap.set("n", "<leader>lf", format,  {buffer = ev.buf, desc = "Format Document" })
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
      vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "code action" })
      vim.keymap.set("n", "<leader>lA", function()
        vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
      end, { buffer = ev.buf, desc = "Source Action" })
      vim.keymap.set({ "n", "v" }, "<leader>lI", "<cmd>checkhealth lsp", { buffer = ev.buf, desc = "LSP Health" })
      vim.keymap.set({ "n", "v" }, "<leader>li", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { buffer = ev.buf, desc = "Toggle Inlay Hints" })
      vim.keymap.set("n", "<leader>hh", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>ck", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>lI", "<Cmd>checkhealth vim.lsp<CR>", { buffer = ev.buf, desc = "Lsp Info" })
      vim.keymap.set("n", "<leader>lm", "<Cmd>Mason<CR>", { buffer = ev.buf, desc = "Mason" })
      vim.keymap.set("n", "<leader>lS", "<Cmd>lsp stop<CR>", { buffer = ev.buf, desc = "Lsp Stop" })
      vim.keymap.set("n", "<leader>lR", "<Cmd>lsp restart<CR>", { buffer = ev.buf, desc = "Lsp Restart" })
      vim.keymap.set({ "n" }, "gai", Snacks.picker.lsp_incoming_calls, { desc = "C[a]lls Incoming" })
      vim.keymap.set({ "n" }, "gao", Snacks.picker.lsp_outgoing_calls, { desc = "C[a]lls Outgoing" })
      vim.keymap.set({ "n" }, "<leader>ss", Snacks.picker.lsp_symbols, { desc = "LSP Symbols" })
      vim.keymap.set({ "n" }, "<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
    end,
  })
end)
