local helpers = require("plugins.helpers")

return {
  name = "jump-to-megamerge",
  fn = function()
    local change_id = helpers.megamerge_change_id()
    if not change_id then
      return
    end
    revisions.navigate({ to = change_id })
  end,
  opts = {
    seq = { "space", "j", "m" },
    scope = "revisions",
    desc = "jump to private: megamerge",
  },
}
