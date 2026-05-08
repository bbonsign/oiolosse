---@type ActionDef
return {
  name = "show-by-author",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No revision selected")
      return
    end
    local email = jj("log", "-r", change_id, "--no-graph", "-T", "author.email()")
    if not email or email == "" then
      flash("Could not determine author")
      return
    end
    email = email:gsub("%s+$", "")
    revset.set(string.format("author(%q)", email))
  end,
  opts = {
    seq = { "space", "v", "A" },
    scope = "revisions",
    desc = "show commits by author of selected revision",
  },
}
