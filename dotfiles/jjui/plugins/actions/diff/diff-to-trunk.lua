return {
  name = "diff-to-trunk",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    exec_shell("jj diff --from " .. change_id .. " --to 'trunk()' | diffnav")
  end,
  opts = {
    seq = { "space", "d", "t" },
    scope = "revisions",
  },
}
