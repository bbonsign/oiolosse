vim.pack.add({ "https://github.com/hat0uma/csvview.nvim" })

---@module "csvview"
---@type CsvView.Options
local opts = {
  parser = { comments = { "#", "//" } },
  view = {
    display_mode = "border",
    header_lnum = 1,
    sticky_header = { enabled = true },
  },
  keymaps = {
    -- Text objects for selecting fields
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    -- Excel-like navigation between fields and rows
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    jump_next_row = { "<Enter>", mode = { "n", "v" } },
    jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
  },
}

require("csvview").setup(opts)

vim.keymap.set("n", "<localleader>csv", "<cmd>CsvViewToggle<cr>", { desc = "Toggle CSV View" })
