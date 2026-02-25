local gitbrowse = require("plugins.gitbrowse")

return {
  name = "browse-file",
  fn = function()
    gitbrowse.browse({ file = true })
  end,
  opts = {
    seq = { "space", "b" },
    scope = "revisions.details",
    desc = "open file in browser",
  },
}
