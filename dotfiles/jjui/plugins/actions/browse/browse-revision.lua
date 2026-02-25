local gitbrowse = require("plugins.gitbrowse")

return {
  name = "browse-revision",
  fn = function()
    gitbrowse.browse()
  end,
  opts = {
    seq = { "space", "b" },
    scope = "revisions",
    desc = "open in browser",
  },
}
