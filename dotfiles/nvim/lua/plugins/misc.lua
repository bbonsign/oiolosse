Config.later(function()
  vim.pack.add({ "https://github.com/mbbill/undotree" })
  vim.keymap.set("n", "<leader>uu", "<Cmd>UndotreeToggle<CR>", { desc = "UndotreeToggle" })

  vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
  require("lazydev").setup()
end)

-- {
--   "dmtrKovalenko/fff.nvim",
--   build = function()
--     -- downloads a prebuilt binary or falls back to cargo build
--     require("fff.download").download_or_build_binary()
--   end,
--   -- for nixos:
--   -- build = "nix run .#release",
--   opts = {
--     layout = {
--       prompt_position = "top",
--       preview_position = "bottom",
--       -- anchor = "bottom",
--       width = 1,
--       -- height = 0.5,
--     },
--     debug = {
--       -- enabled = true,
--       show_scores = true,
--     },
--   },
--   lazy = false, -- the plugin lazy-initialises itself
--   keys = {
--     {
--       "<localleader>ff",
--       function()
--         require("fff").find_files()
--       end,
--       desc = "FFFind files",
--     },
--     {
--       "<localleader>fg",
--       function()
--         require("fff").live_grep()
--       end,
--       desc = "LiFFFe grep",
--     },
--     {
--       "<localleader>fz",
--       function()
--         require("fff").live_grep()
--       end,
--       desc = "Live fffuzy grep",
--     },
--     {
--       "<localleader>fc",
--       function()
--         require("fff").live_grep({ query = vim.fn.expand("<cword>") })
--       end,
--       desc = "Search current word",
--     },
--   },
-- },

-- {
--   "Owen-Dechow/videre.nvim",
--   cmd = "Videre",
--   dependencies = {
--     -- "Owen-Dechow/graph_view_yaml_parser", -- Optional: add YAML support
--     -- "Owen-Dechow/graph_view_toml_parser", -- Optional: add TOML support
--     -- "a-usr/xml2lua.nvim", -- Optional | Experimental: add XML support
--   },
--   keys = {
--     { "<localleader><C-j>", "<Cmd>Videre<CR>" },
--   },
--   opts = {
--     -- round_units = false,
--     simple_statusline = true, -- If you are just starting out with Videre,
--     --   setting this to `false` will give you
--     --   descriptions of available keymaps.
--   },
-- },
