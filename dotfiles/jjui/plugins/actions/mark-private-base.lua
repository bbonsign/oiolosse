return {
  name = "mark-private-base",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end

    local description = jj("log", "--no-graph", "-r", change_id, "-T", "description")
    local trimmed_description = string.gsub(description or "", "^%s*(.-)%s*$", "%1")
    if trimmed_description ~= "" then
      flash("Revision already has a description")
      return
    end

    local empty_revset = 'change_id("' .. change_id .. '") & empty()'
    local empty_match = jj("log", "--no-graph", "-r", empty_revset, "-T", "change_id")
    local trimmed_empty_match = string.gsub(empty_match or "", "^%s*(.-)%s*$", "%1")
    if trimmed_empty_match == "" then
      flash("Revision is not empty")
      return
    end

    jj("describe", "-r", change_id, "--message", "private: base")
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "m", "b" },
    scope = "revisions",
    desc = "set description to private: base when empty",
  },
}
