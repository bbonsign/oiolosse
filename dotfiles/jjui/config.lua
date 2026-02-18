local my_binds = require("plugins.my_binds")
local my_actions = require("plugins.my_actions")

---@param config Config
function setup(config)
  my_binds.setup(config)
  my_actions.setup(config)
end
