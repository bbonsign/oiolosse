return {
  name = "show-default",
  fn = function()
    revset.set("present(@) | ancestors(immutable_heads().., 2) | present(trunk())")
  end,
  opts = {
    seq = { "space", "v", "d" },
    scope = "revisions",
    desc = "show default revisions",
  },
}
