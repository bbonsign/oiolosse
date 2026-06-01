local M = {}

function M.switch_case()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word = vim.fn.expand("<cword>")
  local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

  -- Detect camelCase
  if word:find("[a-z][A-Z]") then
    -- Convert camelCase to snake_case
    local snake_case_word = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
  -- Detect snake_case
  elseif word:find("_[a-z]") then
    -- Convert snake_case to camelCase
    local camel_case_word = word:gsub("(_)([a-z])", function(_, l)
      return l:upper()
    end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
  else
    print("Not a snake_case or camelCase word")
  end
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean, buf?:number}
---@return string
function M.get_root(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect({ all = false, buf = buf })
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end
  if opts and opts.normalize then
    return ret
  end
  return M.is_win() and ret:gsub("/", "\\") or ret
end

function M.git()
  local root = M.get_root()
  local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
  local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
  return ret
end

return M
