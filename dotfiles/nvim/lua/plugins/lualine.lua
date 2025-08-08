-- `get_scrollbar_widget` and `get_fileinfo_widget`
-- originially from: https://github.com/mcauley-penney/nvim/blob/35b59cdf3f737a7894f5e0240224dbfa01d8fb16/lua/ui/statusline.lua
local hl_str = function(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
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

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local icons = require("lazyvim.config").icons
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
      hl_group = "lualine_c_normal",
    })

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "snacks_dashboard", "dashboard", "alpha" },
          tabline = { "snacks_dashboard", "dashboard", "alpha", "lazy" },
        },
        separator = "",
        section_separators = { left = "", right = "" },
      },
      tabline = {
        lualine_a = {
          {
            function()
              return " "
            end,
            color = "lualine_c_normal",
          },
        },
        lualine_b = {
          {
            function()
              return get_fileinfo_widget()
            end,
            color = "lualine_c_normal",
          },
        },
        lualine_c = {},
        lualine_x = {
          { symbols.get, cond = symbols.has },
        },
        lualine_z = {
          {
            "tabs",
            separator = "",
            section_separators = { left = "", right = "" },
          },
        },
      },
      sections = {
        lualine_a = {
          {
            function()
              return " "
            end,
            padding = { left = 0, right = 0 },
            color = {},
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
          },

          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            separator = "",
            padding = { left = 0, right = 1 },
            on_click = function()
              Snacks.picker.git_status()
            end,
          },
        },

        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            padding = { left = 1, right = 0 },
            on_click = function()
              Snacks.picker.diagnostics()
            end,
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            path = 1,
            padding = { left = 1, right = 0 },
            symbols = {
              modified = " ", -- Text to show when the file is modified.
              readonly = " ", -- Text to show when the file is non-modifiable or readonly.
              -- unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]", -- Text to show for new created file before first writting
            },
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
            -- color = Util.ui.fg("Constant"),
            color = { fg = Snacks.util.color("Constant") },
          },
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = { fg = Snacks.util.color("Debug") },
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = Snacks.util.color("Special") },
            on_click = function()
              require("lazy").home()
            end,
          },
        },

        lualine_y = {
          {
            "location",
            padding = { left = 1, right = 1 },
            color = "lualine_c_normal",
            -- color = {
            --   fg = Snacks.util.color("lualine_c_normal", "fg"),
            --   bg = Snacks.util.color("lualine_c_normal", "bg"),
            -- },
          },
          {
            get_scrollbar_widget,
            padding = { left = 0, right = 0 },
            -- color = { fg = Snacks.util.color("Constant") },
            color = "lualine_a_inactive",
            cond = nil,
            on_click = function()
              vim.cmd.write()
            end,
          },
          {
            "progress",
            color = "lualine_a_inactive",
            padding = { left = 1, right = 0 },
          },
        },

        lualine_z = {
          {
            "fileformat",
            color = "lualine_a_inactive",
            padding = { left = 1, right = 1 },
          },
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
