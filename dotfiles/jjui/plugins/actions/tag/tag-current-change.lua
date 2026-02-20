return {
  name = "tag-current-change",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    local user_input = input({
      title = "Tag name",
      prompt = "Enter a tag_name: ",
    }) or ""
    local tag_name = string.gsub(user_input, "%s", "")
    if not tag_name then
      flash("No tag_name")
      return
    end
    jj("tag", "set", "-r", change_id, tag_name)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "t", "t" },
    scope = "revisions",
    desc = "tag change under cursor",
  },
}
