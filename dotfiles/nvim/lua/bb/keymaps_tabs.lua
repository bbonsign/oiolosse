-- Tab management keymaps.
-- Each binding is registered under two prefixes (`<leader><tab>` and the
-- shorter `<leader>t`). Going to a tab by number is additionally available as
-- the bare `<leader><number>`.
local M = {}

local function rename_tab()
  vim.ui.input({ prompt = "Tab name: " }, function(name)
    if name then
      vim.cmd("LualineRenameTab " .. name)
    end
  end)
end

local function tabs_picker()
  Snacks.picker.pick("tabs")
end

-- { suffix, rhs, desc }. `rhs` may be a command string or a function.
local mappings = {
  { "o", "<cmd>tabonly<cr>", "Close Other Tabs" },
  { "f", "<cmd>tabfirst<cr>", "First Tab" },
  { "n", "<cmd>tabnew<cr>", "New Tab" },
  { "]", "<cmd>tabnext<cr>", "Next Tab" },
  { "L", "<cmd>tablast<cr>", "Next Tab" },
  { "l", "<cmd>tabnext<cr>", "Next Tab" },
  { "d", "<cmd>tabclose<cr>", "Close Tab" },
  { "k", "<cmd>tabclose<cr>", "Close Tab" },
  { "q", "<cmd>tabclose<cr>", "Close Tab" },
  { "[", "<cmd>tabprevious<cr>", "Previous Tab" },
  { "H", "<cmd>tabfirst<cr>", "First Tab" },
  { "h", "<cmd>tabprevious<cr>", "Previous Tab" },
  { "r", rename_tab, "Rename Tab" },
  { "<tab>", tabs_picker, "Tabs Picker" },
}

local prefixes = { "<leader><tab>", "<leader>t" }

function M.setup()
  for _, prefix in ipairs(prefixes) do
    for _, m in ipairs(mappings) do
      vim.keymap.set("n", prefix .. m[1], m[2], { desc = m[3] })
    end
    -- go to tab by number under each prefix
    for i = 1, 9 do
      vim.keymap.set("n", prefix .. i, "<cmd>" .. i .. "tabnext<cr>", { desc = "Go to Tab " .. i })
    end
  end

  -- bare <leader><number> shortcut to go to that tab
  for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, "<cmd>" .. i .. "tabnext<cr>", { desc = "Go to Tab " .. i })
  end
end

return M
