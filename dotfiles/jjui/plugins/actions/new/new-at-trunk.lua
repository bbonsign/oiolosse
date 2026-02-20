local helpers = require("plugins.helpers")

return {
  name = "new-at-trunk",
  fn = function()
    jj("new", "trunk()")
    local change_id = helpers.working_copy_change_id()
    revisions.refresh({ selected_revision = change_id })
  end,
  opts = {
    seq = { "space", "n", "t" },
    scope = "revisions",
  },
}
