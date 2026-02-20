local M = {}

local function get_script_dir()
  local info = debug.getinfo(1, "S")
  local source = info.source:match("^@?(.+)$")
  if source then
    local handle = io.popen('realpath "' .. source .. '"')
    if handle then
      local abs = handle:read("*l")
      handle:close()
      if abs then
        return abs:match("(.*/)") or "./"
      end
    end
  end
  return "./"
end

local function load_actions(dir)
  local actions = {}
  local handle = io.popen('find "' .. dir .. '" -name "*.lua" -type f 2>/dev/null | sort')
  if handle then
    for file in handle:lines() do
      local chunk, load_err = loadfile(file)
      if not chunk then
        flash("Failed to load " .. file .. ": " .. tostring(load_err))
      else
        local ok, action = pcall(chunk)
        if ok and action then
          table.insert(actions, action)
        elseif not ok then
          flash("Error in " .. file .. ": " .. tostring(action))
        end
      end
    end
    handle:close()
  end
  return actions
end

---@param config Config
function M.setup(config)
  local dir = get_script_dir() .. "actions/"
  for _, a in ipairs(load_actions(dir)) do
    config.action(a.name, a.fn, a.opts)
  end
end

return M
