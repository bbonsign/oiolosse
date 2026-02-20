local helpers = require("plugins.helpers")

return {
  name = "new-at-bookmark",
  fn = function()
    local bookmark = helpers.choose_bookmark()
    if bookmark then
      jj("new", "--insert-after", bookmark)
      local change_id = helpers.working_copy_change_id()
      revisions.refresh({ selected_revision = change_id })
    else
      flash("none selected")
    end
  end,
  opts = {
    seq = { "space", "n", "B" },
    scope = "revisions",
    desc = "new change at bookmark",
  },
}
