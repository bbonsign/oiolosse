return {
  "chrisgrieser/nvim-origami",
  -- enabled = false,
  event = "VeryLazy",
  opts = {
    foldtext = {
      enabled = package.loaded["ufo"] == nil,
      -- template = "     %s lines", -- `%s` gets the number of folded lines
      hlgroupForCount = "@string",
    },

    foldKeymaps = {
      setup = true, -- modifies `h` and `l`
      hOnlyOpensOnFirstColumn = true,
    },
  },
}
