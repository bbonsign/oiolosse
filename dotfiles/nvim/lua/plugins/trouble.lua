return {
  "folke/trouble.nvim",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble<cr>",
      desc = "Trouble",
    },
    {
      "<leader>xs",
      "<cmd>Trouble lsp_document_symbols toggle focus=true win.position=right<cr>",
      desc = "Doc Symbols (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
  },

  opts = {
    auto_preview = false,
    use_diagnostic_signs = true,
  },
}
