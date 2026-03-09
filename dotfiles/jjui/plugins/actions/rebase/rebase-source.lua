return {
  name = "rebase-source",
  fn = function()
    revisions.open_rebase()
    revisions.rebase.set_source({ source = "source" })
  end,
  opts = {
    key = "R",
    scope = "revisions",
    desc = "rebase --source current revision",
  },
}
