local helpers = require("plugins.helpers")

---@type ActionDef
return {
  name = "rebase-source-to-private-base",
  fn = function()
    local source = context.change_id()
    if not source then
      flash("No change_id")
      return
    end

    local destination = helpers.private_base_change_id()
    if not destination then
      return
    end

    jj("rebase", "--source", source, "--destination", destination)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "r", "B" },
    scope = "revisions",
    desc = "rebase --source current revision onto private: base",
  },
}
