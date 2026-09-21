local helpers = require("plugins.helpers")

return {
  name = "megamerge",
  fn = helpers.create_megamerge,
  opts = {
    seq = { "space", "M" },
    scope = "revisions",
  },
}
