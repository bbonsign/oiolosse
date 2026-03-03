local helpers = require("plugins.helpers")

return {
  name = "rebase-megamerge-to-private-base",
  fn = function()
    local selected = context.change_id()
    if not helpers.is_megamerge_change_id(selected) then
      flash("Select a revision with description private: megamerge*")
      return
    end

    local destination = helpers.private_base_change_id()
    if not destination then
      return
    end

    jj("rebase", "--revisions", "all:roots(main..@)", "--destination", destination)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "r", "m", "b" },
    scope = "revisions",
    desc = "rebase megamerge branches onto private: base",
  },
}
