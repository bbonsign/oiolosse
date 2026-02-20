return {
  name = "rebase-source",
  fn = function()
    revisions.start_rebase({ source = "descendants" })
  end,
  opts = {
    key = "R",
    scope = "revisions",
    desc = "rebase --source current revision",
  },
}
