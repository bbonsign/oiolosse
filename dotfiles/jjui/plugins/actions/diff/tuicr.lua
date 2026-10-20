---@type ActionDef
return {
  name = "tuicr",
  fn = function()
    local revisions = context.checked_commit_ids()
    if not revisions or #revisions == 0 then
      local commit_id = context.commit_id()
      if not commit_id then
        flash("No revision selected")
        return
      end
      revisions = { commit_id }
    end

    jj_interactive("util", "exec", "--", "tuicr", "--revisions", table.concat(revisions, " | "))
  end,
  opts = {
    seq = { "space", "d", "r" },
    scope = "revisions",
    desc = "review revisions in tuicr",
  },
}
