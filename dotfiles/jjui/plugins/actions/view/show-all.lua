return {
  name = "show-all",
  fn = function()
    revset.set("all()")
  end,
  opts = {
    seq = { "space", "v", "a" },
    scope = "revisions",
    desc = "show all revisions",
  },
}
