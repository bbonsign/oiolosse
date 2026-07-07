local helpers = require("plugins.helpers")

---@type ActionDef
return {
  name = "show-target",
  fn = function()
    local target = helpers.choose_target({ title = "Show target and ancestors" })
    if not target then
      return
    end
    revset.set(string.format("::%s", target))
  end,
  opts = {
    seq = { "space", "v", "p" },
    scope = "revisions",
    desc = "choose a bookmark/tag and show it with its ancestors",
  },
}
