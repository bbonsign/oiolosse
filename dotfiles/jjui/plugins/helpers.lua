local M = {}

---@param s string|nil
---@return string
local function trim(s)
  return string.gsub(s or "", "^%s*(.-)%s*$", "%1")
end

---Show a `choose` popup with a live-updating substring filter.
---Requires a jjui build where filterable `choose` popups open directly in filter
---mode (the local "choose-filter" patch). The search input is shown immediately
---and the list narrows as you type; Enter selects, Esc cancels.
---@param options string[] The full list of options
---@param title? string Title shown on the choose popup
---@return string|nil selected The chosen option, or nil if cancelled
local function choose_filtered(options, title)
  return choose({
    title = title,
    options = options,
    filter = true,
  })
end

---Show a selection menu of bookmarks and return the chosen one.
---@param opts? {title?: string, tracked?: boolean}
---@return string|nil bookmark The selected bookmark name (with @remote suffix if applicable), or nil if cancelled
function M.choose_bookmark(opts)
  opts = opts or {}
  local template = 'if(remote, name ++ "@" ++ remote, name) ++ "\\n"'
  local bookmarks, err
  if opts.tracked then
    bookmarks, err = jj("bookmark", "list", "--tracked", "-T", template)
  else
    bookmarks, err = jj("bookmark", "list", "-T", template)
  end
  if err then
    flash({ text = "Failed to list bookmarks: " .. err, error = true })
    return nil
  end

  return choose_filtered(split_lines(bookmarks), opts.title or "Choose a bookmark")
end

---Show a selection menu of bookmarks and tags and return the chosen target.
---Local bookmarks appear as `name`, remote bookmarks as `name@remote`, and tags as `name`.
---@param opts? {title?: string}
---@return string|nil target The selected bookmark/tag name, or nil if cancelled
function M.choose_target(opts)
  opts = opts or {}
  local options = {}

  local bookmark_template = 'if(remote, name ++ "@" ++ remote, name) ++ "\\n"'
  local bookmarks, berr = jj("bookmark", "list", "--all", "-T", bookmark_template)
  if berr then
    flash({ text = "Failed to list bookmarks: " .. berr, error = true })
    return nil
  end
  for _, name in ipairs(split_lines(bookmarks)) do
    table.insert(options, name)
  end

  local tags, terr = jj("tag", "list", "-T", 'name ++ "\\n"')
  if terr then
    flash({ text = "Failed to list tags: " .. terr, error = true })
    return nil
  end
  for _, name in ipairs(split_lines(tags)) do
    table.insert(options, name)
  end

  if #options == 0 then
    flash("No bookmarks or tags found")
    return nil
  end

  return choose_filtered(options, opts.title or "Choose a target")
end

---Evaluate a jj template against a single revision.
---@param revision string Revision (e.g., "main", "main@origin", "@", "trunk()")
---@param template string A jj template expression (e.g., "change_id.shortest()", "description")
---@return string|nil result
---@return string|nil error
function M.log_template(revision, template)
  return jj("log", "-r", revision, "--no-graph", "-T", template, "--limit", "1")
end

---Returns the change ID of a given bookmark.
---@param revision string Revision (e.g., "main", "main@origin", "@", "trunk()"), should specify one change id
---@return string|nil change_id
---@return string|nil error
function M.change_id_of_revision(revision)
  return M.log_template(revision, "change_id.shortest()")
end

---Returns the change ID of the working copy (@ revision).
---@return string|nil change_id
---@return string|nil error
function M.working_copy_change_id()
  return M.change_id_of_revision("@")
end

---Returns the change ID of the revision with description "private: base", or flashes an error.
---@return string|nil change_id
function M.private_base_change_id()
  local change_id, err = M.change_id_of_revision('description(glob:"private: base*")')
  if err or not change_id or change_id == "" then
    flash({ text = "No revision with description 'private: base' found", error = true })
    return nil
  end
  return change_id
end

---Returns the change ID of the first revision with description "private: megamerge*", or flashes an error.
---@return string|nil change_id
function M.megamerge_change_id()
  local change_id, err = M.change_id_of_revision('description(glob:"private: megamerge*")')
  if err or not change_id or change_id == "" then
    flash({ text = "No revision with description 'private: megamerge' found", error = true })
    return nil
  end
  return change_id
end

---Returns whether the revision's description starts with "private: megamerge".
---@param change_id string|nil
---@return boolean is_megamerge
function M.is_megamerge_change_id(change_id)
  if not change_id then
    return false
  end

  local description, err = M.log_template(change_id, "description")
  if err then
    flash({ text = "Failed to read revision description: " .. err, error = true })
    return false
  end

  return trim(description):match("^private: megamerge") ~= nil
end

---Find or choose a megamerge revision. If one exists, returns its change_id.
---If multiple exist, shows a choose() menu. Returns nil on error or cancellation.
---@return string|nil change_id
function M.find_or_choose_megamerge()
  local output, err = jj(
    "log",
    "-r",
    'description(glob:"private: megamerge*")',
    "--no-graph",
    "-T",
    'change_id.shortest() ++ " " ++ description.first_line() ++ "\\n"'
  )
  if err or not output or output == "" then
    flash({ text = "No megamerge revisions found", error = true })
    return nil
  end

  local lines = split_lines(output)
  if #lines == 0 then
    flash({ text = "No megamerge revisions found", error = true })
    return nil
  end

  local choice
  if #lines == 1 then
    choice = lines[1]
  else
    choice = choose({
      title = "Choose megamerge target",
      options = lines,
    })
    if not choice then
      return nil
    end
  end

  local change_id = choice:match("^(%S+)")
  if not change_id then
    flash({ text = "Could not determine megamerge change id", error = true })
    return nil
  end
  return change_id
end

---Return checked change_ids (or commit_ids) excluding the megamerge itself.
---@param megamerge string The megamerge change_id to exclude
---@param use_commit_ids? boolean If true, use checked_commit_ids instead of checked_change_ids
---@return string[]|nil targets Filtered list, or nil if empty
function M.checked_targets_excluding(megamerge, use_commit_ids)
  local checked
  if use_commit_ids then
    checked = context.checked_commit_ids()
  else
    checked = context.checked_change_ids()
  end
  local targets = {}
  for _, cid in ipairs(checked or {}) do
    if cid ~= megamerge then
      table.insert(targets, cid)
    end
  end
  if #targets == 0 then
    return nil
  end
  return targets
end

return M
