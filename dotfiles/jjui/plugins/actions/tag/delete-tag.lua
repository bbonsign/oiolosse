return {
  name = "delete-tag",
  fn = function()
    local output, err = jj("tag", "list", "-T", "name ++ '\n'")
    local choice = choose({
      title = "Choose a tag",
      options = split_lines(output),
    })
    if not choice then
      flash("none selected")
      return
    end
    jj("tag", "delete", choice)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "t", "d" },
    scope = "revisions",
  },
}
