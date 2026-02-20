return {
  name = "megamerge",
  fn = function()
    local checked = context.checked_commit_ids()
    if not checked or #checked == 0 then
      flash("Check revisions to merge")
      return
    end
    local args = { "new" }
    for _, cid in ipairs(checked) do
      table.insert(args, cid)
    end
    jj(args)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "m", "m" },
    scope = "revisions",
  },
}
