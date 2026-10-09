--!nonstrict
local STATE = "submap-hints.model"
local model = noctalia.state.get(STATE) or {}
local opened = false

local function description(binding)
  local action = binding.action
  if action == "submap:reset" then
    return noctalia.tr("panel.back")
  elseif string.sub(action, 1, 7) == "submap:" then
    return noctalia.tr("panel.enter", { submap = string.sub(action, 8) })
  elseif string.sub(action, 1, 6) == "spawn:" then
    local command = string.sub(action, 7)
    command = string.gsub(command, "^noctalia msg ", "")
    command = string.gsub(command, "^%$HOME/%.local/kitty%.app/bin/kitty", "kitty")
    command = string.gsub(command, "^%$HOME/%.local/bin/", "")
    return command
  end
  return string.gsub(action, "-", " ")
end

local function render()
  if not opened then
    return
  end
  if type(model.submap) ~= "string" then
    -- The service serializes visibility IPC. Do not independently close here:
    -- an in-flight open followed by reset/re-entry could otherwise stay closed.
    panel.render(ui.column({}, {}))
    return
  end
  local rows = {}
  for _, binding in ipairs(model.bindings or {}) do
    local suffix = ""
    if binding.after == "reset" then
      suffix = noctalia.tr("panel.reset")
    elseif type(binding.after) == "string" then
      suffix = noctalia.tr("panel.after", { submap = binding.after })
    end
    table.insert(
      rows,
      ui.row({ key = binding.key, gap = 12, align = "center" }, {
        ui.label({ text = binding.key, width = 90, color = "primary", fontWeight = "bold", maxLines = 1 }),
        ui.label({ text = description(binding) .. suffix, flexGrow = 1, maxLines = 2 }),
      })
    )
  end
  if model.error then
    table.insert(rows, ui.label({ text = model.error, color = "error", maxLines = 4 }))
  elseif #rows == 0 then
    table.insert(rows, ui.label({ text = noctalia.tr("panel.empty"), color = "on_surface_variant" }))
  end
  -- Balanced columns keep the entire personal leader menu visible without
  -- scrolling. Larger custom menus remain scrollable with the pointer.
  local columns = {}
  local count = #rows > 16 and 3 or (#rows > 8 and 2 or 1)
  local perColumn = math.ceil(#rows / count)
  for column = 1, count do
    local children = {}
    for index = (column - 1) * perColumn + 1, math.min(column * perColumn, #rows) do
      table.insert(children, rows[index])
    end
    table.insert(columns, ui.column({ key = tostring(column), flexGrow = 1, gap = 10 }, children))
  end
  panel.render(ui.column({ gap = 16, flexGrow = 1 }, {
    ui.label({ text = noctalia.tr("panel.title", { submap = model.submap }), fontSize = 18, fontWeight = "bold" }),
    ui.scroll({ flexGrow = 1, align = "stretch" }, {
      ui.row({ gap = 24, align = "start" }, columns),
    }),
    ui.label({ text = noctalia.tr("panel.footer"), color = "on_surface_variant", fontSize = 12 }),
  }))
end

noctalia.state.watch(STATE, function(value)
  model = value or {}
  render()
end)

function onOpen(_context)
  opened = true
  model = noctalia.state.get(STATE) or {}
  render()
end

function onClose()
  opened = false
end
