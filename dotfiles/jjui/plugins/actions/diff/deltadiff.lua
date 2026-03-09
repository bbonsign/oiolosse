return {
  name = "deltadiff",
  fn = function()
    local change_id = context.change_id()
    local file = context.file() or ""
    jj_interactive(
      "util",
      "exec",
      "--",
      "bash",
      "-c",
      string.format("jj diff --summary --git --color always -r %s %s | diffnav", change_id, file)
    )
  end,
  opts = {
    key = "d",
    scope = "revisions.details",
  },
}
