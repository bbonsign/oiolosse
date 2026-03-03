local helpers = require("plugins.helpers")

return {
  name = "rebase-megamerge-to-trunk",
  fn = function()
    local change_id = context.change_id()
    if not helpers.is_megamerge_change_id(change_id) then
      flash("Select a revision with description private: megamerge*")
      return
    end

    jj("rebase", "--revisions", "all:roots(main..@)", "--destination", "trunk()")
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "r", "m", "t" },
    scope = "revisions",
    desc = "rebase megamerge branches onto trunk()",
  },
}
