local helpers = require("plugins.helpers")

---@type ActionDef
return {
  name = "show-public",
  fn = function()
    local base = helpers.private_base_change_id()
    if not base then
      return
    end
    revset.set(string.format('trunk():: ~ %s::', base))
  end,
  opts = {
    seq = { "space", "v", "p" },
    scope = "revisions",
    desc = "show trunk descendants excluding private base descendants",
  },
}
