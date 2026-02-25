local M = {}

-- Patterns to convert git remote URLs to HTTPS browse URLs
-- Adapted from folke/snacks.nvim gitbrowse.lua
-- stylua: ignore
M.remote_patterns = {
  { "^(https?://.*)%.git$",                "%1" },
  { "^git@(.+):(.+)%.git$",               "https://%1/%2" },
  { "^git@(.+):(.+)$",                    "https://%1/%2" },
  { "^git@(.+)/(.+)$",                    "https://%1/%2" },
  { "^org%-%d+@(.+):(.+)%.git$",          "https://%1/%2" },
  { "^ssh://git@(.*)$",                   "https://%1" },
  { "^ssh://([^:/]+)(:%d+)/(.*)$",        "https://%1/%3" },
  { "^ssh://([^/]+)/(.*)$",               "https://%1/%2" },
  { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
  { "^https://%w*@(.*)",                  "https://%1" },
  { "^git@(.*)",                           "https://%1" },
  { ":%d+",                                "" },
  { "%.git$",                              "" },
}

---Convert a git remote URL to an HTTPS browse URL.
---@param remote string Raw remote URL (e.g., "git@github.com:user/repo.git")
---@return string url HTTPS browse URL
function M.remote_to_url(remote)
  local url = remote
  for _, pattern in ipairs(M.remote_patterns) do
    url = url:gsub(pattern[1], pattern[2])
  end
  if url:find("https://") ~= 1 then
    url = "https://" .. url
  end
  return url
end

---Get the first remote's fetch URL from jj.
---@return string|nil url The remote URL
---@return string|nil error Error message
function M.get_remote_url()
  local output, err = jj("git", "remote", "list")
  if err then
    return nil, err
  end
  local url = output:match("%S+%s+(%S+)")
  if not url then
    return nil, "No git remotes found"
  end
  return url, nil
end

---Get the HTTPS browse URL for the repo.
---@return string|nil url The browse URL
---@return string|nil error Error message
function M.get_repo_url()
  local remote, err = M.get_remote_url()
  if not remote then
    return nil, err
  end
  return M.remote_to_url(remote), nil
end

-- URL path patterns per forge for commit/file/branch views
-- stylua: ignore
M.url_patterns = {
  ["github%.com"] = {
    commit       = "/commit/{commit}",
    file         = "/blob/{commit}/{file}",
    file_default = "/blob/HEAD/{file}",
    branch       = "/tree/{branch}",
  },
  ["gitlab%.com"] = {
    commit       = "/-/commit/{commit}",
    file         = "/-/blob/{commit}/{file}",
    file_default = "/-/blob/HEAD/{file}",
    branch       = "/-/tree/{branch}",
  },
  ["bitbucket%.org"] = {
    commit       = "/commits/{commit}",
    file         = "/src/{commit}/{file}",
    file_default = "/src/HEAD/{file}",
    branch       = "/src/{branch}",
  },
  ["git%.sr%.ht"] = {
    commit       = "/commit/{commit}",
    file         = "/tree/{commit}/item/{file}",
    file_default = "/tree/HEAD/item/{file}",
    branch       = "/tree/{branch}",
  },
}

---Build a forge-specific URL from a repo base URL.
---@param repo_url string Base HTTPS repo URL
---@param what "repo"|"commit"|"file"|"branch"
---@param fields? {commit?: string, file?: string, branch?: string}
---@return string url
function M.build_url(repo_url, what, fields)
  if what == "repo" or not fields then
    return repo_url
  end
  for pattern, templates in pairs(M.url_patterns) do
    if repo_url:find(pattern) then
      local template = templates[what]
      if template then
        return repo_url .. template:gsub("{(%w+)}", function(key)
          return fields[key] or key
        end)
      end
    end
  end
  return repo_url
end

---Browse the repo, optionally targeting a specific commit or file.
---@param opts? {context_aware?: boolean, file?: boolean}
function M.browse(opts)
  opts = opts or {}
  local repo_url, err = M.get_repo_url()
  if not repo_url then
    flash({ text = "Failed to get repo URL: " .. (err or "unknown error"), error = true })
    return
  end

  local what = "repo"
  local fields = {}

  if opts.file then
    local file = context.file()
    if file then
      what = "file_default"
      fields = { file = file }
    end
  end

  if opts.context_aware then
    local short_commit = context.commit_id()
    local commit_id = nil
    if short_commit then
      local full, resolve_err = jj("log", "-r", short_commit, "--no-graph", "-T", "commit_id", "--limit", "1")
      if not resolve_err and full and full ~= "" then
        commit_id = full
      end
    end
    local file = context.file()

    if file and commit_id then
      what = "file"
      fields = { commit = commit_id, file = file }
    elseif commit_id then
      what = "commit"
      fields = { commit = commit_id }
    end
  end

  local url = M.build_url(repo_url, what, fields)
  M.open_url(url)
  flash("Opened " .. url)
end

---Open a URL in the default browser.
---@param url string
function M.open_url(url)
  os.execute('xdg-open "' .. url .. '" >/dev/null 2>&1 &')
end

---Open the repo's main page in the browser.
function M.open_repo()
  local url, err = M.get_repo_url()
  if not url then
    flash({ text = "Failed to get repo URL: " .. (err or "unknown error"), error = true })
    return
  end
  M.open_url(url)
  flash("Opened " .. url)
end

return M
