local M = {}

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

  return choose({
    title = opts.title or "Choose a bookmark",
    options = split_lines(bookmarks),
  })
end

---Returns the change ID of a given bookmark.
---@param revision string Revision (e.g., "main", "main@origin", "@", "trunk()"), should specify one change id
---@return string|nil change_id
---@return string|nil error
function M.change_id_of_revision(revision)
  return jj("log", "-r", revision, "--no-graph", "-T", "change_id.shortest()", "--limit", "1")
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

return M
