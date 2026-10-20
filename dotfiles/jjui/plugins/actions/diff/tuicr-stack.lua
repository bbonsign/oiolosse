---@type ActionDef
return {
  name = "tuicr-stack",
  fn = function()
    local commit_id = context.commit_id()
    if not commit_id then
      flash("No revision selected")
      return
    end

    jj_interactive("util", "exec", "--", "tuicr", "--revisions", "trunk().." .. commit_id)
  end,
  opts = {
    seq = { "space", "d", "R" },
    scope = "revisions",
    desc = "review stack in tuicr",
  },
}
