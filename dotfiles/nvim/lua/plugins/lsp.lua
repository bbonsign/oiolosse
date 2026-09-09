local now_if_args = Config.now_if_args

vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  -- NOTE: mason-lspconfig automatically enables servers installed via mason
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup()
require("mason-lspconfig").setup()

local function pyright_hover()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "pyright" })

  if #clients == 0 then
    vim.notify("Pyright is not attached to this buffer", vim.log.levels.WARN)
    return
  end

  local client = clients[1]
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  client:request("textDocument/hover", params, function(err, result, context)
    vim.lsp.handlers["textDocument/hover"](err, result, context, { border = "rounded" })
  end, bufnr)
end

local mouse_hover_id = 0

local function hover_at_mouse(bufnr)
  mouse_hover_id = mouse_hover_id + 1
  local hover_id = mouse_hover_id
  local mouse = vim.fn.getmousepos()

  if mouse.winid ~= vim.api.nvim_get_current_win() or mouse.line == 0 or mouse.column == 0 then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(mouse.winid)
  local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
  local function still_current()
    return hover_id == mouse_hover_id
      and vim.api.nvim_buf_is_valid(bufnr)
      and vim.api.nvim_win_is_valid(mouse.winid)
      and mouse.winid == vim.api.nvim_get_current_win()
      and vim.api.nvim_win_get_buf(mouse.winid) == bufnr
      and vim.api.nvim_buf_get_changedtick(bufnr) == changedtick
      and vim.deep_equal(vim.api.nvim_win_get_cursor(mouse.winid), cursor)
      and vim.api.nvim_get_mode().mode == "n"
      and vim.deep_equal(vim.fn.getmousepos(), mouse)
      and #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" }) > 0
  end

  vim.defer_fn(function()
    if not still_current() then
      return
    end

    vim.lsp.buf_request_all(bufnr, "textDocument/hover", function(client)
      return {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
        position = {
          line = mouse.line - 1,
          character = vim.lsp.util.character_offset(bufnr, mouse.line - 1, mouse.column - 1, client.offset_encoding),
        },
      }
    end, function(results)
      if not still_current() then
        return
      end

      for _, response in pairs(results) do
        if not response.err and response.result and response.result.contents then
          vim.lsp.handlers.hover(nil, response.result, response.context, {
            focusable = false,
            relative = "mouse",
            silent = true,
          })
          return
        end
      end
    end)
  end, 300)
end

vim.lsp.config("pyright", {
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
  },
  on_attach = function(client)
    -- Keep Pyright synchronized for explicit requests, but let ty provide all
    -- regular LSP features without duplicate results.
    for capability in pairs(client.server_capabilities) do
      if capability:match("Provider$") then
        client.server_capabilities[capability] = false
      end
    end
  end,
})

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
  vim.lsp.enable({
    "nixd",
    "nushell",
  })

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
      vim.keymap.set("n", "<leader>lh", pyright_hover, { buffer = ev.buf, desc = "Pyright Hover" })
      vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<leader>ck", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
      vim.keymap.set("n", "<MouseMove>", function()
        hover_at_mouse(ev.buf)
      end, { buffer = ev.buf, desc = "Hover at Mouse" })
      vim.keymap.set("n", "<leader>lI", "<Cmd>checkhealth vim.lsp<CR>", { buffer = ev.buf, desc = "Lsp Info" })
      vim.keymap.set("n", "<leader>lm", "<Cmd>Mason<CR>", { buffer = ev.buf, desc = "Mason" })
      vim.keymap.set("n", "<leader>lS", "<Cmd>lsp enable<CR>", { buffer = ev.buf, desc = "Lsp Stop" })
      vim.keymap.set("n", "<leader>lQ", "<Cmd>lsp stop<CR>", { buffer = ev.buf, desc = "Lsp Stop" })
      vim.keymap.set("n", "<leader>lR", "<Cmd>lsp restart<CR>", { buffer = ev.buf, desc = "Lsp Restart" })
      vim.keymap.set({ "n" }, "gai", Snacks.picker.lsp_incoming_calls, { desc = "C[a]lls Incoming" })
      vim.keymap.set({ "n" }, "gao", Snacks.picker.lsp_outgoing_calls, { desc = "C[a]lls Outgoing" })
      vim.keymap.set({ "n" }, "<leader>ss", Snacks.picker.lsp_symbols, { desc = "LSP Symbols" })
      vim.keymap.set({ "n" }, "<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
    end,
  })
end)
