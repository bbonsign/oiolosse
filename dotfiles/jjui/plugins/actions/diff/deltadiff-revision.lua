return {
  name = "deltadiff-revision",
  fn = function()
    local change_id = context.change_id()
    jj_interactive(
      "util",
      "exec",
      "--",
      "bash",
      "-c",
      string.format("jj show --git --color always -r %s | diffnav", change_id)
    )
  end,
  opts = {
    key = "d",
    scope = "revisions",
  },
}
