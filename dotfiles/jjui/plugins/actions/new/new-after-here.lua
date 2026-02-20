return {
  name = "new-after-here",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    jj("new", "--insert-after", change_id)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "n", "a" },
    scope = "revisions",
  },
}
