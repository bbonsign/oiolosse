-- Session management via mini.sessions (no lazy.nvim required).
-- Snacks' built-in dashboard `session` section auto-detects session plugins
-- through `Snacks.dashboard.have_plugin`, which only works under lazy.nvim. We
-- bypass that by wiring the dashboard key directly to `M.restore`, using one
-- global session per cwd.
local MiniSessions = require("mini.sessions")

-- Custom tab names (set via :LualineRenameTab, stored in the `tabname` tabpage
-- var) are not saved by :mksession. We persist them through a session global
-- (`g:TabNames`): its name starts uppercase + has a lowercase letter, so it is
-- one of the few globals `:mksession` writes when `globals` is in
-- 'sessionoptions'. We snapshot names (in tab order) before writing, and
-- reapply them after reading.
local function save_tab_names()
  local names = {}
  for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
    local ok, tabname = pcall(vim.api.nvim_tabpage_get_var, tabid, "tabname")
    names[#names + 1] = (ok and type(tabname) == "string") and tabname or ""
  end
  vim.g.TabNames = vim.json.encode(names)
end

local function restore_tab_names()
  if type(vim.g.TabNames) ~= "string" then
    return
  end
  local ok, names = pcall(vim.json.decode, vim.g.TabNames)
  if not ok or type(names) ~= "table" then
    return
  end
  for i, tabid in ipairs(vim.api.nvim_list_tabpages()) do
    if type(names[i]) == "string" and names[i] ~= "" then
      pcall(vim.api.nvim_tabpage_set_var, tabid, "tabname", names[i])
    end
  end
  vim.cmd.redrawtabline()
end

MiniSessions.setup({
  autoread = false,
  autowrite = true, -- auto-save the active session on exit
  directory = vim.fn.stdpath("data") .. "/session",
  hooks = {
    pre = { write = save_tab_names },
    post = { read = restore_tab_names },
  },
})

local M = {}

local function cwd_session_name()
  return (vim.fn.getcwd():gsub("[\\/:+ ]", "_"))
end

local function session_path()
  return MiniSessions.config.directory .. "/" .. cwd_session_name()
end

function M.save()
  MiniSessions.write(cwd_session_name(), { force = true })
end

function M.restore()
  if vim.fn.filereadable(session_path()) == 1 then
    MiniSessions.read(cwd_session_name(), { force = true })
  else
    vim.notify("No saved session for " .. vim.fn.getcwd(), vim.log.levels.INFO)
  end
end

-- Only worth saving a session when there is at least one real file buffer open,
-- so we don't litter the session dir when opening + quitting on the dashboard.
local function has_real_buffer()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
      and vim.api.nvim_buf_get_name(buf) ~= ""
    then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if has_real_buffer() then
      M.save()
    end
  end,
  desc = "Auto-save session for cwd on exit",
})

return M
