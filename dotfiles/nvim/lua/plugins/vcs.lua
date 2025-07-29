return {
  {
    -- Select hunks to split in jj
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    init = function()
      local tokyonight = require("tokyonight.colors").setup()
      vim.api.nvim_set_hl(0, "HunkTreeDirIcon", { fg = tokyonight.border })
      vim.api.nvim_set_hl(0, "HunkTreeSelectionIcon", { fg = tokyonight.border })
    end,
    opts = {
      keys = {
        tree = {
          toggle_file = { "a", " " },
        },
        diff = {
          toggle_line = { "a" },
          prev_hunk = { "[h", "[g" },
          next_hunk = { "]h", "]g" },
        },
      },
      ui = {
        tree = {
          mode = "nested", --  `nested` or `flat`
          width = 35,
        },
        layout = "vertical", -- `vertical` or `horizontal`
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      preview_config = { border = "rounded" },

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

    -- stylua: ignore start
    map("n", "<leader>gj", function() Snacks.terminal.toggle("jjui") end, "jjui")
    map("n", "]g", gs.next_hunk, "Next Hunk")
    map("n", "[g", gs.prev_hunk, "Prev Hunk")
    map("n", "]h", gs.next_hunk, "Next Hunk")
    map("n", "[h", gs.prev_hunk, "Prev Hunk")
    -- map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    -- map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
    map("n", "<leader>gd", gs.diffthis, "Diff This")
    map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
}
