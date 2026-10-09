--!nonstrict
local PANEL = "bbonsign/submap-hints:hints"
local STATE = "submap-hints.model"
local desired = false
local revision = 0
local applied = -1
local pending = false

-- Explicit, serialized open/close IPC avoids toggle races during rapid layers.
local function reconcile()
  if pending or applied == revision then
    return
  end
  local target = desired
  local targetRevision = revision
  pending = true
  local accepted = noctalia.runAsync(
    { "noctalia", "msg", target and "panel-open" or "panel-close", PANEL },
    function(result)
      pending = false
      applied = targetRevision
      if result.exitCode ~= 0 or result.timedOut then
        noctalia.log("Submap Hints panel IPC failed: " .. result.stderr)
      end
      reconcile()
    end,
    2000
  )
  if not accepted then
    pending = false
    noctalia.log("Submap Hints panel IPC was rejected")
  end
end

local function publish(model)
  noctalia.state.set(STATE, model)
  desired = type(model.submap) == "string"
  revision += 1
  reconcile()
end

-- runStream uses a shell; exec makes the helper itself the host-owned process.
local function quote(value)
  return "'" .. string.gsub(value, "'", "'\\''") .. "'"
end

publish({})
if noctalia.commandExists("umbriel") and noctalia.commandExists("python3") then
  local started = noctalia.runStream(
    "exec python3 -u "
      .. quote(noctalia.pluginDir() .. "/bindings.py")
      .. " "
      .. quote(noctalia.getConfig("bindings_file")),
    function(line)
      local model = noctalia.json.decode(line)
      if type(model) == "table" then
        if type(model.error) == "string" then
          noctalia.log("Submap Hints: " .. model.error)
        end
        publish(model)
      end
    end
  )
  if not started then
    noctalia.log("Submap Hints could not start its binding reader")
  end
else
  noctalia.log("Submap Hints needs umbriel and Python 3.11+ on PATH")
end
