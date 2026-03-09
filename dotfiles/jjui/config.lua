local my_binds = require("plugins.my_binds")
local my_actions = require("plugins.my_actions")
local dynamic_theme = require("plugins.dynamic_theme")

---@param config Config
function setup(config)
  my_binds.setup(config)
  my_actions.setup(config)
  dynamic_theme.setup("#5B8DEF", config)
end
