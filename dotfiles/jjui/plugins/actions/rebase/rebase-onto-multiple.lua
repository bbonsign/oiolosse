return {
  name = "rebase-onto-multiple",
  fn = function()
    local change_id = context.change_id()
    local checked = context.checked_commit_ids()
    if not change_id or not checked or #checked == 0 then
      flash("Select a revision and check targets")
      return
    end
    local args = { "rebase", "-s", change_id }
    for _, cid in ipairs(checked) do
      table.insert(args, "--onto")
      table.insert(args, cid)
    end
    jj(args)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "r", "m" },
    scope = "revisions",
  },
}
