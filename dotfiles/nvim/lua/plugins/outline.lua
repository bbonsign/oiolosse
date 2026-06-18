local kind_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  markdown = false,
  help = false,
  -- you can specify a different filter for each filetype
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    -- "Package", -- remove package since luals uses it for control flow structures
    "Property",
    "Struct",
    "Trait",
  },
}

vim.pack.add({
  "https://github.com/hedyhli/outline.nvim",
})

local opts = require("outline.config").defaults
opts.keymaps.hover_symbol = "K"
opts.keymaps.toggle_preview = "<nop>"
require("outline").setup(opts)

--   opts = function()
--     local defaults = require("outline.config").defaults
--     local opts = {
--       symbols = {
--         icons = {},
--         filter = vim.deepcopy(LazyVim.config.kind_filter),
--       },
--       keymaps = {
--         up_and_jump = "<up>",
--         down_and_jump = "<down>",
--       },
--     }
--
--     for kind, symbol in pairs(defaults.symbols.icons) do
--       opts.symbols.icons[kind] = {
--         icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
--         hl = symbol.hl,
--       }
--     end
--     return opts
--   end,
-- }

vim.keymap.set("n", "<leader>cs", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
