-- Adapted from tpope/vim-unimpaired's put mappings (s:putline).
-- Linewise paste that reindents the pasted text to match the current line.
-- https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim
local M = {}

-- `how` is the put command to run (e.g. "[p" or "]p").
local function putline(how)
  local reg = vim.v.register
  local body = vim.fn.getreg(reg)
  local rtype = vim.fn.getregtype(reg)

  local body_save, type_save
  -- Detect read-only registers (:, %, .) and redirect through the unnamed register.
  if reg:match("[:%%.]") then
    body_save = vim.fn.getreg('"')
    type_save = vim.fn.getregtype('"')
    reg = '"'
    vim.fn.setreg('"', body, rtype)
  end

  if rtype == "V" then
    vim.cmd('normal! "' .. reg .. how)
  else
    -- Force linewise paste, then restore the register's original type.
    vim.fn.setreg(reg, body, "l")
    vim.cmd('normal! "' .. reg .. how)
    vim.fn.setreg(reg, body, rtype)
  end

  if body_save ~= nil then
    vim.fn.setreg('"', body_save, type_save)
  end
end

-- Put above ([p / [P).
function M.above()
  putline("[p")
end

-- Put below (]p / ]P).
function M.below()
  putline("]p")
end

-- `how` is the put command ("[p" or "]p"), `adjust` is the trailing operator
-- applied to the pasted region (">", "<", "=").
local function put_adjust(how, adjust)
  putline(tostring(vim.v.count1) .. how)
  vim.cmd("normal! " .. adjust .. "']")
end

-- Put below and shift right (>p).
function M.below_rightward()
  put_adjust("]p", ">")
end

-- Put above and shift right (>P).
function M.above_rightward()
  put_adjust("[p", ">")
end

-- Put below and shift left (<p).
function M.below_leftward()
  put_adjust("]p", "<")
end

-- Put above and shift left (<P).
function M.above_leftward()
  put_adjust("[p", "<")
end

-- Put below and reformat (=p).
function M.below_reformat()
  put_adjust("]p", "=")
end

-- Put above and reformat (=P).
function M.above_reformat()
  put_adjust("[p", "=")
end

return M
