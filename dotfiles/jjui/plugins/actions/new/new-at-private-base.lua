local helpers = require("plugins.helpers")

return {
  name = "new-at-private-base",
  fn = function()
    jj("new", 'description(glob:"private: base*")')
    local change_id = helpers.working_copy_change_id()
    revisions.refresh({ selected_revision = change_id })
  end,
  opts = {
    seq = { "space", "n", "b" },
    scope = "revisions",
    desc = "new on top of private: base",
  },
}
