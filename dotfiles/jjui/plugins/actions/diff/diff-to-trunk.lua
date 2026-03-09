return {
  name = "diff-to-trunk",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change_id")
      return
    end
    jj_interactive(
      "util",
      "exec",
      "--",
      "bash",
      "-c",
      string.format("jj diff --from %s --to 'trunk()' | diffnav", change_id)
    )
  end,
  opts = {
    seq = { "space", "d", "t" },
    scope = "revisions",
  },
}
