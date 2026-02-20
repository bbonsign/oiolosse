return {
  name = "copy-changeid",
  fn = function()
    local change_id = context.change_id()
    if change_id then
      copy_to_clipboard(change_id)
      flash("Copied change ID: " .. change_id)
      return
    end
    flash("No item selected to copy")
  end,
  opts = {
    seq = { "space", "y", "c" },
    desc = "Copy change id",
    scope = "revisions.details",
  },
}
