-- Config.later(function()
vim.pack.add({
  "https://github.com/folke/trouble.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
})

-- `get_scrollbar_widget` and `get_fileinfo_widget`
-- originially from: https://github.com/mcauley-penney/nvim/blob/35b59cdf3f737a7894f5e0240224dbfa01d8fb16/lua/ui/statusline.lua
local hl_str = function(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

local bg_color = function()
  return Snacks.util.color("StatusLine", "bg")
end

-- insert grouping separators in numbers
-- viml regex: https://stackoverflow.com/a/42911668
-- lua pattern: stolen from Akinsho
local group_number = function(num, sep)
  if num < 999 then
    return tostring(num)
  else
    num = tostring(num)
    return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
  end
end

local function get_scrollbar_widget()
  local sbar_chars = {
    "▔",
    "🮂",
    "🬂",
    "🮃",
    "▀",
    "▄",
    "▃",
    "🬭",
    "▂",
    "▁",
  }

  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
  local sbar = string.rep(sbar_chars[i], 2)

  -- return hl_str("Function", sbar)
  return sbar
end

local function get_vlinecount_str()
  local raw_count = vim.fn.line(".") - vim.fn.line("v")
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

  return group_number(math.abs(raw_count), ",")
end

--- Get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_widget()
  -- local ft = vim.api.nvim_get_option_value("filetype", {})
  local lines = group_number(vim.api.nvim_buf_line_count(0), ",")

  local wc_table = vim.fn.wordcount()
  if wc_table.visual_words and wc_table.visual_chars then
    -- Visual selection mode: line count, word count, and char count
    return table.concat({
      "‹›",
      " ",
      get_vlinecount_str(),
      " lines  ",
      group_number(wc_table.visual_words, ","),
      " words  ",
      group_number(wc_table.visual_chars, ","),
      " chars",
    })
  else
    return table.concat({ "󰍜", " ", lines, " lines" })
  end
end

--- Get search term and match count for the current search
--- @return string search info
local function get_search_widget()
  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
  if not ok or not result.total or result.total == 0 then
    return ""
  end

  local term = vim.fn.getreg("/")
  local current = result.current
  if result.incomplete == 1 then -- timed out
    current = "?"
  elseif result.incomplete == 2 then -- max count exceeded
    if result.total > result.maxcount and result.current > result.maxcount then
      current = ">" .. result.maxcount
    end
  end

  return table.concat({ " ", term, "  ", current, "/", result.total })
end

local icons = Config.icons
-- For symbol hierarchy hint
local trouble = require("trouble")
local symbols = trouble.statusline({
  mode = "lsp_document_symbols",
  groups = {},
  title = false,
  filter = { range = true },
  format = "{kind_icon}{symbol.name:Normal}",
  -- The following line is needed to fix the background color
  -- Set it to the lualine section you want to use
  -- hl_group = "StatusLine",
})

require("lualine").setup({
  options = {
    -- theme = "tokyonight",
    -- color = { bg = bg_color() },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { "snacks_dashboard", "dashboard", "alpha" },
      tabline = { "snacks_dashboard", "dashboard", "alpha", "lazy" },
    },
    separator = "",
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  tabline = {

    lualine_a = {
      {
        function()
          return " "
        end,
        padding = { left = 0, right = 0 },
        -- color = { bg = bg_color() },
        cond = nil,
        on_click = function()
          vim.cmd.write()
        end,
      },
    },

    lualine_b = {
      {
        "branch",
        fmt = function(str)
          -- truncate long branch names
          return str:sub(0, 35)
        end,
        separator = "",
        padding = { left = 1, right = 1 },
        on_click = function()
          Snacks.picker.git_status()
        end,
        color = { bg = bg_color() },
      },

      -- {
      --   "diff",
      --   symbols = {
      --     added = icons.git.added,
      --     modified = icons.git.modified,
      --     removed = icons.git.removed,
      --   },
      --   separator = "",
      --   padding = { left = 0, right = 1 },
      --   on_click = function()
      --     Snacks.picker.git_status()
      --   end,
      --   color = { bg = bg_color() },
      -- },
    },

    lualine_c = {
      -- {
      --   "diagnostics",
      --   symbols = {
      --     error = icons.diagnostics.Error,
      --     warn = icons.diagnostics.Warn,
      --     info = icons.diagnostics.Info,
      --     hint = icons.diagnostics.Hint,
      --   },
      --   padding = { left = 1, right = 0 },
      --   on_click = function()
      --     Snacks.picker.diagnostics()
      --   end,
      -- },
      {
        function()
          return " "
        end,
        padding = { left = 2, right = 0 },
        -- color = { bg = bg_color() },
        cond = nil,
        on_click = function()
          vim.cmd.write()
        end,
      },
      {
        "filename",
        path = 1,
        padding = { left = 0, right = 0 },
        symbols = {
          modified = " ", -- Text to show when the file is modified.
          readonly = " ", -- Text to show when the file is non-modifiable or readonly.
          -- unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for new created file before first writting
        },
        color = { bg = bg_color() },
      },
      {
        "filetype",
        -- icon_only = true,
        separator = "",
        padding = { left = 1, right = 0 },
        -- color = { bg = bg_color() },
      },
    },

    lualine_x = {
      {
        function()
          return require("noice").api.status.mode.get()
        end,
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.mode.has()
        end,
        color = { fg = Snacks.util.color("Constant"), bg = bg_color() },
      },
      {
        function()
          return "  " .. require("dap").status()
        end,
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
        color = { fg = Snacks.util.color("Debug"), bg = bg_color() },
      },
    },

    lualine_y = {
      {
        function()
          return get_fileinfo_widget()
        end,
        color = { bg = bg_color() },
      },
      {
        "location",
        padding = { left = 1, right = 1 },
        color = { fg = Snacks.util.color("Special"), bg = bg_color() },
      },
      {
        "progress",
        color = { fg = Snacks.util.color("StatusLine"), bg = bg_color() },
        padding = { left = 0, right = 1 },
      },
      {
        get_scrollbar_widget,
        padding = { left = 0, right = 0 },
        -- color = { fg = Snacks.util.color("Constant") },
        color = { fg = Snacks.util.color("StatusLine"), bg = bg_color() },
        cond = nil,
        on_click = function()
          vim.cmd.write()
        end,
      },
    },

    lualine_z = {
      {
        "fileformat",
        color = { fg = Snacks.util.color("StatusLine"), bg = bg_color() },
        padding = { left = 1, right = 1 },
      },
    },
  },
  sections = {
    lualine_a = {
      {
        "tabs",
        mode = 2,
        show_modified_status = false, -- Shows a symbol next to the tab name if the file has been modified.
        -- use_mode_colors = true,
        tabs_color = {
          -- Same values as the general color option can be used here.
          -- active = "lualine_{section}_normal", -- Color for active tab.
          -- inactive = "lualine_{section}_inactive", -- Color for inactive tab.
        },
      },
      -- {
      --   function()
      --     local proc = vim.system({"jj", "log", "--limit", "1", "--template", [[change_id.shortest() ++ ": " ++ description]]})
      --     local res = proc:wait(300)
      --     return string.gsub(res.stdout, "%s+", "")
      --   end,
      --   -- color = { bg = bg_color() },
      -- },
      {
        function()
          return " "
        end,
        color = { bg = bg_color() },
      },
    },
    lualine_b = {
      {
        get_search_widget,
        cond = function()
          return vim.v.hlsearch == 1
        end,
        color = { fg = Snacks.util.color("Special"), bg = bg_color() },
        padding = { left = 1, right = 1 },
      },
    },
    lualine_c = {
      {
        color = { bg = bg_color() },
      },
    },
    lualine_x = {
      {
        symbols.get,
        cond = symbols.has,
        color = { bg = bg_color() },
      },
    },
    lualine_z = {},
  },
  extensions = { "neo-tree" },
})
-- end)
