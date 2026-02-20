local helpers = require("plugins.helpers")

return {
  name = "jump-to-bookmark",
  fn = function()
    local bookmark = helpers.choose_bookmark({ tracked = true, title = "Jump to bookmark" })
    if not bookmark then
      return
    end
    local change_id, id_err = helpers.bookmark_change_id(bookmark)
    if id_err then
      flash({ text = "Failed to resolve bookmark: " .. id_err, error = true })
      return
    end
    revisions.navigate({ to = change_id })
  end,
  opts = {
    seq = { "space", "j", "j" },
    scope = "revisions",
    desc = "jump to bookmark",
  },
}
