return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    enabled = false,
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- stylua: ignore start
      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end)
      set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end)
      set({ "n", "x" }, "<C-S-n>", function() mc.matchAddCursor(-1) end)
      set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<a-q>", mc.toggleCursor)
      -- stylua: ignore end

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    -- enabled = false,
    config = function()
      vim.cmd([[
        let g:VM_theme = 'nord'

        " Set in keymaps.lua
        let g:VM_leader = ';'

        let g:VM_maps = {}
        let g:VM_maps['Motion ;'] = ';;'
        " let g:VM_maps['Add Cursor Down'] = '<C-j>'
        " let g:VM_maps['Add Cursor Up'] = '<C-k>'

        let g:VM_mouse_mappings = 1

        let g:VM_Mono_hl   = 'DiffChange'
        let g:VM_Extend_hl = 'DiffAdd'
        let g:VM_Cursor_hl = 'Visual'
        let g:VM_Insert_hl = 'DiffChange'

        let g:VM_highlight_matches = 'underline'
      ]])
    end,
    keys = {
      "<C-up>",
      "<C-down>",
      "<C-n>",
    },
  },
}
