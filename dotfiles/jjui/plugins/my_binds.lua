local M = {}

function M.setup(config)
  config.bind({
    action = "ui.open_revset",
    key = "R",
    scope = "revisions",
    desc = "revset",
  })
end

return M
