---@type ActionDef
return {
  name = "show-ancestors",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No revision selected")
      return
    end
    revset.set(string.format("::%s", change_id))
  end,
  opts = {
    seq = { "space", "v", "j" },
    scope = "revisions",
    desc = "show selected revision and its ancestors",
  },
}
