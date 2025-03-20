return {
  -- { "folke/noice.nvim", enabled = false },

  { "tpope/vim-unimpaired" },

  { "mbbill/undotree" },

  -- {
  --   "ibhagwan/smartyank.nvim",
  --   opts = {
  --     -- Use builtin highlight on yank from nvim/LazyVim
  --     highlight = {
  --       enabled = false, -- highlight yanked text
  --       higroup = "IncSearch", -- highlight group of yanked text
  --       timeout = 2000, -- timeout for clearing the highlight
  --     },
  --     clipboard = {
  --       enabled = true,
  --     },
  --     tmux = {
  --       enabled = true,
  --       -- remove `-w` to disable copy to host client's clipboard
  --       cmd = { "tmux", "set-buffer", "-w" },
  --     },
  --     osc52 = {
  --       enabled = true,
  --       -- escseq = 'tmux',     -- use tmux escape sequence, only enable if
  --       -- you're using tmux and have issues (see #4)
  --       ssh_only = true, -- false to OSC52 yank also in local sessions
  --       silent = false, -- true to disable the "n chars copied" echo
  --       echo_hl = "Directory", -- highlight group of the OSC52 echo message
  --     },
  --     -- By default copy is only triggered by "intentional yanks" where the
  --     -- user initiated a `y` motion (e.g. `yy`, `yiw`, etc). Set to `false`
  --     -- if you wish to copy indiscriminately:
  --     validate_yank = true,
  --     --
  --     -- For advanced customization set to a lua function returning a boolean
  --     -- for example, the default condition is:
  --     -- validate_yank = function() return vim.v.operator == "y" end,
  --   },
  -- },

  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          tailwind = true,
          -- mode = "virtualtext",
          -- virtualtext = "■",
        },
      })
    end,
  },

  -- { "echasnovski/mini.operators", version = false },
}
