local helpers = require("plugins.helpers")

return {
  name = "rebase-private-base-to-trunk",
  fn = function()
    local source = helpers.private_base_change_id()
    if not source then
      return
    end

    jj("rebase", "--source", source, "--destination", "trunk()")
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "r", "b" },
    scope = "revisions",
    desc = "rebase private: base onto trunk()",
  },
}
