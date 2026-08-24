Config.later(function()
  vim.pack.add({ "https://github.com/bbonsign/gitsigns.nvim" })

  require("gitsigns").setup({
    preview_config = { border = "rounded" },
    trouble = false, -- don't open quickfix in trouble's version

    on_attach = function(buffer)
      local gitsigns = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

        -- stylua: ignore start
        map("n", "<leader>gj", function() Snacks.terminal.toggle("jjui") end, "jjui")

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map("n", "]g", gitsigns.next_hunk, "Next Hunk")
        map("n", "[g", gitsigns.prev_hunk, "Prev Hunk")
        map("n", "]h", gitsigns.next_hunk, "Next Hunk")
        map("n", "[h", gitsigns.prev_hunk, "Prev Hunk")
        map("n", "<leader>gQ", function() gitsigns.setqflist("all") end, "Hunks-Repo Quickfix")
        map("n", "<leader>gq", gitsigns.setqflist, "Hunks-Buffer Quickfix")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
        map('n', '<leader>gr', gitsigns.reset_hunk)
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        -- map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        -- map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
        map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gB", gitsigns.blame, "Blame")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff This")
        map("n", "<leader>gD", function() gitsigns.diffthis("~") end, "Diff This ~")
        map("n", "<leader>gw", gitsigns.toggle_word_diff, "Toggle Word Diff")
    end,
  })
end)
