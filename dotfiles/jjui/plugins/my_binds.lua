local M = {}

-- https://github.com/idursun/jjui/blob/8b517545d5b1f063c33fa4d0efa0ae13b56176c5/internal/config/default/bindings.toml
local my_binds = {
  {
    key = "__none__",
    action = "revisions.absorb",
    scope = "revisions",
    desc = "absorb",
  },
  {
    key = "__none__",
    action = "revisions.details.absorb",
    scope = "revisions.details",
    desc = "absorb",
  },
  {
    key = "A",
    action = "revisions.abandon",
    scope = "revisions",
    desc = "abandon",
  },
  {
    key = "ctrl+j",
    action = "revisions.jump_to_parent",
    scope = "revisions",
    desc = "jump to parent",
  },
  {
    key = "ctrl+k",
    action = "revisions.jump_to_children",
    scope = "revisions",
    desc = "jump to children",
  },
  {
    key = "v",
    action = "revisions.toggle_select",
    scope = "revisions",
    desc = "select",
  },
  {
    key = "v",
    action = "revisions.details.toggle_select",
    scope = "revisions.details",
    desc = "select",
  },
  {
    action = "ui.open_revset",
    key = "R",
    scope = "revisions",
    desc = "revset",
  },
}

function M.setup(config)
  for _, bind in ipairs(my_binds) do
    config.bind(bind)
  end
end

return M
