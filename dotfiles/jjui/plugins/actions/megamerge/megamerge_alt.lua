local helpers = require("plugins.helpers")

return {
  name = "megamerge_",
  fn = helpers.create_megamerge,
  opts = {
    seq = { "space", "m", "m", "m" },
    scope = "revisions",
  },
}
