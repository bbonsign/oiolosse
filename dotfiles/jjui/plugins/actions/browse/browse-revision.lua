local gitbrowse = require("plugins.gitbrowse")

return {
  name = "browse-revision",
  fn = function()
    gitbrowse.browse()
  end,
  opts = {
    seq = { "space", "B" },
    scope = "revisions",
    desc = "open in browser",
  },
}
