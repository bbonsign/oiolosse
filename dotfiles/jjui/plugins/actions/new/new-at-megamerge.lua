local helpers = require("plugins.helpers")

return {
  name = "new-at-megamerge",
  fn = function()
    local megamerge = helpers.find_or_choose_megamerge()
    if not megamerge then
      return
    end

    jj("new", megamerge)
    local change_id = helpers.working_copy_change_id()
    revisions.refresh({ selected_revision = change_id })
  end,
  opts = {
    seq = { "space", "n", "m" },
    scope = "revisions",
    desc = "new change on top of megamerge",
  },
}
