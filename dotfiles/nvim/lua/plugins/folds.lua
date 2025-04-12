return {
  "chrisgrieser/nvim-origami",
  event = "VeryLazy",
  opts = {
    foldtextWithLineCount = {
      enabled = package.loaded["ufo"] == nil,
      template = "    %s lines", -- `%s` gets the number of folded lines
      hlgroupForCount = "Comment",
    },

    foldKeymaps = {
      setup = true, -- modifies `h` and `l`
      hOnlyOpensOnFirstColumn = true,
    },
  },
}
