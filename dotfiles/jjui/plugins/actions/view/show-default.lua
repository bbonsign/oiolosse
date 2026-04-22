return {
  name = "show-default",
  fn = function()
    revset.reset()
  end,
  opts = {
    seq = { "space", "v", "d" },
    scope = "revisions",
    desc = "show default revisions",
  },
}
