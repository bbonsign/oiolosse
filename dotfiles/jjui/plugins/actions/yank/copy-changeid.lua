return {
  name = "copy-changeid",
  fn = function()
    local change_id = context.change_id()
    if change_id then
      local full_change_id, err = jj("log", "-r", change_id, "--no-graph", "-T", "change_id", "--limit", "1")
      if err or not full_change_id then
        flash({ text = "Failed to resolve full change ID", error = true })
        return
      end
      copy_to_clipboard(full_change_id)
      flash(string.format("Copied change ID: %s", full_change_id))
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
