return {
  name = "edit-file",
  fn = function()
    local file = context.file()
    if not file then
      flash("No file selected")
      return
    end
    exec_shell("$EDITOR " .. '"' .. file .. '"')
  end,
  opts = {
    seq = { "space", "e" },
    scope = "revisions.details",
    desc = "edit selected file",
  },
}
