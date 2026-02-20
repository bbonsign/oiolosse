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
      "jj diff --summary --git --color always -r " .. change_id .. " " .. file .. " | diffnav"
    )
  end,
  opts = {
    key = "d",
    scope = "revisions.details",
  },
}
