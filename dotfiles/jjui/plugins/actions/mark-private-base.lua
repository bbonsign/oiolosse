local helpers = require("plugins.helpers")

return {
  name = "mark-private-base",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end

    local empty_revset = string.format('change_id("%s") & empty()', change_id)
    local empty_match = helpers.log_template(empty_revset, "change_id")
    local trimmed_empty_match = string.gsub(empty_match or "", "^%s*(.-)%s*$", "%1")
    if trimmed_empty_match == "" then
      flash("Revision is not empty")
      return
    end

    jj("bookmark", "set", "private-base", "--revision", change_id, "--allow-backwards")
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "m", "b" },
    scope = "revisions",
    desc = "set private-base bookmark on empty revision",
  },
}
