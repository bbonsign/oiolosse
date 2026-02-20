return {
  name = "move-commit-down",
  fn = function()
    local change_id = context.change_id()
    local checked = context.checked_commit_ids()
    if not change_id or not checked or #checked == 0 then
      flash("Check revisions to move")
      return
    end
    local args = { "rebase" }
    for _, cid in ipairs(checked) do
      table.insert(args, "-r")
      table.insert(args, cid)
    end
    table.insert(args, "--insert-before")
    table.insert(args, change_id)
    jj(args)
    revisions.refresh()
  end,
  opts = {
    key = "J",
    scope = "revisions",
  },
}
