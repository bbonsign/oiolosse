return {
  {
    "nicolasgb/jj.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {},
    keys = {
      {
        "<leader>jd",
        function()
          local cmd = require("jj.cmd")
          cmd.describe()
        end,
        desc = "JJ describe",
      },
      {
        "<leader>jL",
        function()
          local cmd = require("jj.cmd")
          local file = vim.fn.expand("%:p")
          cmd.log({ revisions = string.format("files(%s)", file) })
        end,
        desc = "JJ log for file",
      },
      {
        "<leader>jl",
        function()
          local cmd = require("jj.cmd")
          cmd.log()
        end,
        desc = "JJ log",
      },
      {
        "<leader>je",
        function()
          local cmd = require("jj.cmd")
          cmd.edit()
        end,
        desc = "JJ edit",
      },
      {
        "<leader>jn",
        function()
          local cmd = require("jj.cmd")
          cmd.new()
        end,
        desc = "JJ new",
      },
      {
        "<leader>js",
        function()
          local cmd = require("jj.cmd")
          cmd.status()
        end,
        desc = "JJ status",
      },
      {
        "<leader>sj",
        function()
          local cmd = require("jj.cmd")
          cmd.squash()
        end,
        desc = "JJ squash",
      },
      {
        "<leader>ju",
        function()
          local cmd = require("jj.cmd")
          cmd.undo()
        end,
        desc = "JJ undo",
      },
      {
        "<leader>jy",
        function()
          local cmd = require("jj.cmd")
          cmd.redo()
        end,
        desc = "JJ redo",
      },
      {
        "<leader>jr",
        function()
          local cmd = require("jj.cmd")
          cmd.rebase()
        end,
        desc = "JJ rebase",
      },
      {
        "<leader>jb",
        function()
          local cmd = require("jj.cmd")
          cmd.bookmark_create()
        end,
        desc = "JJ bookmark create",
      },
      {
        "<leader>jB",
        function()
          local cmd = require("jj.cmd")
          cmd.bookmark_delete()
        end,
        desc = "JJ bookmark delete",
      },

      -- Diff commands
      {
        "<leader>dj",
        function()
          local diff = require("jj.diff")
          diff.open_vdiff()
        end,
        desc = "JJ diff vertical",
      },
      {
        "<leader>dJ",
        function()
          local diff = require("jj.diff")
          diff.open_hdiff()
        end,
        desc = "JJ diff horizontal",
      },
      -- Pickers
      {
        "<leader>jj",
        function()
          local picker = require("jj.picker")
          picker.status()
        end,
        desc = "JJ Picker status",
      },
      {
        "<leader>jh",
        function()
          local picker = require("jj.picker")
          picker.file_history()
        end,
        desc = "JJ Picker file history",
      },
    },
  },

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
