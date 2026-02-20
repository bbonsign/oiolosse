local helpers = require("plugins.helpers")

return {
  name = "jump-to-private-base",
  fn = function()
    local change_id = helpers.private_base_change_id()
    if not change_id then
      return
    end
    revisions.navigate({ to = change_id })
  end,
  opts = {
    seq = { "space", "j", "b" },
    scope = "revisions",
    desc = "jump to private: base",
  },
}
