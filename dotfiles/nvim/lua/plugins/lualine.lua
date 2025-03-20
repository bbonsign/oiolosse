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
        disabled_filetypes = { statusline = { "dashboard", "alpha" }, tabline = { "oil" } },
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
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          { symbols.get, cond = symbols.has },
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
              require("telescope.builtin").git_status()
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
              require("telescope.builtin").git_status()
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
              require("telescope.builtin").diagnostics()
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
          { "selectioncount" },
          {
            "location",
            padding = { left = 1, right = 1 },
            color = "lualine_c_normal",
            -- color = {
            --   fg = Snacks.util.color("lualine_c_normal", "fg"),
            --   bg = Snacks.util.color("lualine_c_normal", "bg"),
            -- },
          },
          { "progress", padding = { left = 1, right = 0 } },
          { "fileformat", padding = { left = 1, right = 1 } },
        },

        lualine_z = {
          {
            function()
              -- return "  "
              return " "
            end,
            padding = { left = 1, right = 0 },
            color = {},
            cond = nil,
            on_click = function()
              vim.cmd.write()
            end,
          },
          -- {
          --   function()
          --     return " " .. os.date("%R")
          --   end,
          -- },
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
