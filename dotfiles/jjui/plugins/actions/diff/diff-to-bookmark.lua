local helpers = require("plugins.helpers")

return {
  name = "diff-to-bookmark",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    local bookmark = helpers.choose_bookmark()
    if not bookmark then
      flash("None selected")
      return
    end
    exec_shell("jj diff --from " .. change_id .. " --to " .. bookmark .. " | diffnav")
  end,
  opts = {
    seq = { "space", "d", "d" },
    scope = "revisions",
  },
}
