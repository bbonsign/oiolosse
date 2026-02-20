return {
  name = "copy-diff",
  fn = function()
    local diff = jj("diff", "-r", context.change_id(), "--git")
    copy_to_clipboard(diff)
  end,
  opts = {
    key = "Y",
    scope = "revisions",
    desc = "copy diff",
  },
}
