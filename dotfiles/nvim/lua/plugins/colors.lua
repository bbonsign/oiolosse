vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
require("tokyonight").setup({
  transparent = true,
  dim_inactive = true,
  -- use_background = "dark", -- can be light/dark/auto. When auto, background will be set to vim.o.background
  styles = {
    style = "night",
    floats = "transparent",
    sidebars = "transparent",
    -- floats = "dark", -- style for floating windows
    -- sidebars = "dark", -- style for sidebars, see below
  },
  -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  sidebars = {
    "neo-tree",
    "vista_kind",
    "terminal",
    "packer",
    "spectre_panel",
    "NeogitStatus",
    "help",
  },
  on_colors = function(colors)
    -- colors.bg = "#010C20"
    -- colors.bg_dark = "#010C20"
    -- colors.bg_popup = "#010C20"
    -- colors.bg_sidebar = "#010C20"
    colors.border = colors.blue7
    colors.bg_statusline = "#010C21"
  end,
  on_highlights = function(hl, colors)
    hl.FloatBorder.fg = colors.blue7
    hl.LspInfoBorder.fg = colors.blue7
    hl.CursorLine.bg = "#010C21"
    hl.Folded.bg = "#16161E"
  end,
})

vim.cmd.colorscheme("tokyonight")

Config.later(function()
  vim.pack.add({ "https://github.com/NvChad/nvim-colorizer.lua" })
  require("colorizer").setup({
    filetypes = { "*" },
    options = {
      parsers = {
        css = true,
        css_fn = true,
        tailwind = { enable = true },
        hex = { enable = true },
      },
      -- display = {
      --   mode = "virtualtext",
      --   virtualtext = { position = "eol", hl_mode = "foreground" },
      -- },
    },
  })

  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      -- Highlight hex color strings (`#rrggbb`) using that color
      -- hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)
