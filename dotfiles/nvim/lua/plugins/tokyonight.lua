-- https://www.lazyvim.org/configuration/recipes#make-tokyonight-transparent
return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    dim_inactive = true,
    -- use_background = "dark", -- can be light/dark/auto. When auto, background will be set to vim.o.background
    styles = {
      style = "night",
      sidebars = "dark", -- style for sidebars, see below
      -- floats = "transparent",
      floats = "dark", -- style for floating windows
      -- sidebars = "transparent",
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
      colors.bg = "#010C20"
      colors.bg_dark = "#010C20"
      colors.bg_popup = "#010C20"
      colors.bg_sidebar = "#010C20"
      colors.border = colors.blue7
      colors.bg_statusline = "#010C20"
    end,
    on_highlights = function(hl, colors)
      hl.FloatBorder.fg = colors.blue7
      -- hl.LspFloatWinBorder.fg = colors.blue7
      -- hl.LspFloatWinNormal.fg = colors.blue7
      hl.LspInfoBorder.fg = colors.blue7
      -- hl.CmpDocumentationBorder.fg = colors.blue7
      hl.CursorLine.bg = "#010C20"
      -- hl.StatusLine.bg = "#010C20"
      -- hl.StatusLineNC.bg = "#010C20"
    end,
  },
}
