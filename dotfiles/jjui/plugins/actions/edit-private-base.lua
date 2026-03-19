local helpers = require("plugins.helpers")

---@type ActionDef
return {
  name = "edit-private-base",
  fn = function()
    local change_id = helpers.private_base_change_id()
    if not change_id then
      return
    end

    jj("edit", "-r", change_id)
    revisions.refresh()
    revisions.navigate({ to = change_id })
  end,
  opts = {
    seq = { "space", "e", "b" },
    scope = "revisions",
    desc = "edit the private: base commit",
  },
}
