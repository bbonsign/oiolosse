local helpers = require("plugins.helpers")

return {
  name = "restack",
  fn = function()
    -- local change_id = context.change_id()
    -- if not helpers.is_megamerge_change_id(change_id) then
    --   flash("Select a revision with description megamerge*")
    --   return
    -- end

    jj("restack")
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "r", "r" },
    scope = "revisions",
    desc = "restack: rebase mutables trunk()",
  },
}
