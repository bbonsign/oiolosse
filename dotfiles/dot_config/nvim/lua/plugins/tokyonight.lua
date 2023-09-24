-- https://www.lazyvim.org/configuration/recipes#make-tokyonight-transparent
return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    dim_inactive = true,
    use_background = true, -- can be light/dark/auto. When auto, background will be set to vim.o.background
    styles = {
      style = "night",
      sidebars = "dark", -- style for sidebars, see below
      floats = "dark", -- style for floating windows
      -- sidebars = "transparent",
      -- floats = "transparent",
    },
    -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    sidebars = {
      "qf",
      "neo-tree",
      "vista_kind",
      "terminal",
      "packer",
      "spectre_panel",
      "NeogitStatus",
      "help",
    },

    on_colors = function(colors)
      colors.border = colors.blue7
    end,
    on_highlights = function(hl, colors)
      hl.FloatBorder.fg = colors.blue7
      hl.LspFloatWinBorder.fg = colors.blue7
      -- hl.LspFloatWinNormal.fg = colors.blue7
      hl.LspInfoBorder.fg = colors.blue7
      hl.CmpDocumentationBorder.fg = colors.blue7
    end,
  },
}
