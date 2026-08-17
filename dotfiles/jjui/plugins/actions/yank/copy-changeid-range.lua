---@type ActionDef
return {
  name = "copy-changeid-range",
  fn = function()
    local checked = context.checked_change_ids()
    if not checked or #checked ~= 2 then
      flash("Select exactly two changes")
      return
    end

    local first = checked[1]
    local second = checked[2]
    local revset = string.format("((%s::%s) | (%s::%s)) & (%s | %s)", first, second, second, first, first, second)
    local output, err = jj("log", "-r", revset, "--no-graph", "-T", 'change_id ++ "\\n"')
    if err then
      flash({ text = "Failed to resolve change ID range: " .. err, error = true })
      return
    end

    -- jj log returns descendants before ancestors.
    local endpoints = split_lines(output or "")
    if #endpoints ~= 2 then
      flash("Selected changes do not form a range")
      return
    end

    local range = endpoints[2] .. "::" .. endpoints[1]
    local ok, copy_err = copy_to_clipboard(range)
    if ok == false then
      flash({ text = "Failed to copy change ID range: " .. (copy_err or "unknown error"), error = true })
      return
    end
    flash(string.format("Copied change ID range: %s", range))
  end,
  opts = {
    seq = { "space", "y", "r" },
    scope = "revisions",
    desc = "copy change ID range",
  },
}
