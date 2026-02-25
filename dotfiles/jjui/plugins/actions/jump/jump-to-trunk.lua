local helpers = require("plugins.helpers")

return {
  name = "jump-to-trunk",
  fn = function()
    local change_id, id_err = helpers.change_id_of_revision("trunk()")
    if id_err then
      flash({ text = "Failed to resolve bookmark: " .. id_err, error = true })
      return
    end
    revisions.navigate({ to = change_id })
  end,
  opts = {
    seq = { "space", "j", "t" },
    scope = "revisions",
    desc = "jump to trunk",
  },
}
