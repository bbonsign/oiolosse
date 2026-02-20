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
      "jj diff --summary --git --color always -r " .. change_id .. " | diffnav"
    )
  end,
  opts = {
    key = "d",
    scope = "revisions",
  },
}
