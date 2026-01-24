return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- dependencies = "nushell/tree-sitter-nu",
    init = function()
      require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
        local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
        local filename = vim.fn.fnamemodify(filepath, ":t")
        return string.match(filename, ".*mise.*%.toml$") ~= nil
      end, { force = true, all = false })
    end,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      rainbow = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "eex",
        "elixir",
        "fish",
        "gitcommit",
        "gitignore",
        "heex",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "nix",
        "nu",
        "python",
        "query",
        "regex",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },

  {
    "IndianBoy42/tree-sitter-just",
    enabled = true,
  },
}
