return {
  name = "expand-elided",
  fn = function()
    local change_id = revisions.current()
    if not change_id then
      return
    end

    local current = revset.current()
    local bumped = false
    local pattern = string.format("ancestors%%(%s%%s*,%%s*(%%d+)%%)", change_id)
    local updated = current:gsub(pattern, function(n)
      bumped = true
      return string.format("ancestors(%s, %d)", change_id, tonumber(n) + 1)
    end, 1)

    if not bumped then
      updated = string.format("%s | ancestors(%s, 2)", current, change_id)
    end

    revset.set(updated)
  end,
  opts = {
    key = { "+", "=" },
    scope = "revisions",
    desc = "expand elided revisions",
  },
}
