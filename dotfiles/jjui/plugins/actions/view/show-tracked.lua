return {
  name = "show-tracked",
  fn = function()
    revset.set("tracked_remote_bookmarks()::")
  end,
  opts = {
    seq = { "space", "v", "t" },
    scope = "revisions",
    desc = "show tracked remote bookmarks",
  },
}
