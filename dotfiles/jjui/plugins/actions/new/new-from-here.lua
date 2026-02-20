local helpers = require("plugins.helpers")

return {
  name = "new-from-here",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    jj("new", change_id)
    local new_change_id = helpers.working_copy_change_id()
    revisions.refresh({ selected_revision = new_change_id })
  end,
  opts = {
    seq = { "space", "n", "n" },
    scope = "revisions",
  },
}
