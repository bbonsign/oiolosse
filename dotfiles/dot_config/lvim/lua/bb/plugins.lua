local M = {}

M.setup = function()
  -- Additional Plugins
  lvim.plugins = {

    -- { "mhanberg/elixir.nvim",
    --   dependencies = { "nvim-lua/plenary.nvim" },
    --   config = function()
    --     require("elixir").setup()
    --   end },

    { "wsdjeg/vim-fetch" },
    { "tpope/vim-unimpaired" },
    -- { "tpope/vim-vinegar",
    --   event = "BufRead",
    -- },
    -- { "tpope/vim-surround",
    --   'event' = "BufRead",
    -- },
      {
        "kylechui/nvim-surround",
        -- version = "*",  -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
          require('nvim-surround').setup({
            keymaps = {
              insert = "<C-g>s",
              insert_line = "<C-g>S",
              normal = "s",
              normal_cur = "ss",
              normal_line = "yS",
              normal_cur_line = "ySS",
              visual = "s",
              visual_line = "gS",
              delete = "ds",
              change = "cs",
            },
          })
        end
      },
    { "tpope/vim-repeat",
      event = "BufRead",
    },
    { "wellle/targets.vim",
      event = "BufRead",
    },
    { "AndrewRadev/sideways.vim",
      event = "BufRead",
    },

    -- { "nvim-telescope/telescope-file-browser.nvim" },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    { "whatyouhide/vim-textobj-xmlattr",
      event = "BufRead",
      dependencies = "kana/vim-textobj-user"
    },
    { "jceb/vim-textobj-uri",
      event = "BufRead",
      dependencies = "kana/vim-textobj-user"
    },
    { "Julian/vim-textobj-variable-segment",
      event = "BufRead",
      dependencies = "kana/vim-textobj-user"
    },
    { "mbbill/undotree" },
    { "ojroques/nvim-bufdel",
      event = "BufRead",
    },
    { "haya14busa/vim-asterisk",
      event = "BufRead",
      config = function()
        vim.cmd [[
        map *  <Plug>(asterisk-z*)
        map #  <Plug>(asterisk-z#)
        map g* <Plug>(asterisk-gz*)
        map g# <Plug>(asterisk-gz#)
        nnoremap <cr>  <Plug>(asterisk-z*)
        vnoremap <cr>  <Plug>(asterisk-z*)
        let g:asterisk#keeppos = 1
       ]]
      end
    },
    {
      "andymass/vim-matchup",
      -- event = "CursorMoved",
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.g.matchup_matchpref = { html = { tagnameonly = 1 } }
      end,
    },
    -- { "folke/tokyonight.nvim" },  -- default in lunarvim now
    {
      "folke/trouble.nvim",
      cmd      = "TroubleToggle",
      dependencies = "folke/lsp-colors.nvim"
    },
    -- {
    --   "folke/zen-mode.nvim",
    --   cmd = "ZenMode",
    --   config = function()
    --     require("bb.zen").config()
    --   end,
    -- },
    -- {
    --   "folke/twilight.nvim",
    --   cmd = {
    --     "Twilight",
    --     "TwilightEnable",
    --     "TwilightDisable",
    --   },
    --   config = function()
    --     require("twilight").setup {
    --       dimming = { alpha = 0.9 }
    --     }
    --   end
    -- },
    {
      "folke/todo-comments.nvim",
      event = "BufRead",
      config = function()
        require("todo-comments").setup()
      end,
    },
    -- {
    --   "folke/persistence.nvim",
    --   event = "BufReadPre", -- this will only start session saving when an actual file was opened
    --   module = "persistence",
    --   config = function()
    --     require("persistence").setup {
    --       dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
    --       options = { "buffers", "curdir", "tabpages", "winsize" },
    --     }
    --   end,
    -- },
    {
      "kevinhwang91/nvim-bqf",
      event = { "BufRead", "BufNew" },
      config = function()
        require("bqf").setup({
          auto_enable = true,
          preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
          },
          func_map = {
            vsplit = "",
            ptogglemode = "z,",
            stoggleup = "",
          },
          filter = {
            fzf = {
              action_for = { ["ctrl-s"] = "split" },
              extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
            },
          },
        })
      end,
    },

    {
      "roobert/tailwindcss-colorizer-cmp.nvim",
      -- optionally, override the default options:
      config = function()
        require("tailwindcss-colorizer-cmp").setup({
          color_square_width = 2,
        })
      end
    },
    -- {
    --   "hrsh7th/cmp-cmdline",
    --   event = "BufRead",
    --   config = function()
    --     local cmp = require 'cmp'
    --     -- require 'cmp'.setup.cmdline(':', {
    --     --   sources = {
    --     --     { name = 'cmdline' }
    --     --   }
    --     -- })
    --     cmp.setup.cmdline('/', {
    --       mapping = cmp.mapping.preset.cmdline(),
    --       sources = {
    --         { name = 'buffer' }
    --       }
    --     })
    --   end
    -- },
    {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      config = function() require("symbols-outline").setup() end,
    },
    {
      "ray-x/lsp_signature.nvim",
      event = "BufRead",
      config = function() require "lsp_signature".on_attach() end,
    },
    {
      "phaazon/hop.nvim",
      branch = "v2",
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require("hop").setup()
        vim.api.nvim_set_keymap("n", "<leader>j.", ":HopWordCurrentLine<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>jf", ":HopChar1<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>jF", ":HopChar1CurrentLineBC<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>JF", ":HopChar1CurrentLineBC<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>jb", ":HopWordBC<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>jw", ":HopWordAC<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>jj", ":HopLineStartAC<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>jk", ":HopLineStartBC<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>j/", ":HopPattern<cr>", {})
      end,
    },
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
          }
        })
      end,
    },
    -- {
    --   "ruifm/gitlinker.nvim",
    --   event = "BufRead",
    --   config = function()
    --     require("gitlinker").setup {
    --       opts = {
    --         -- remote = 'github', -- force the use of a specific remote
    --         -- adds current line nr in the url for normal mode
    --         add_current_line_on_normal_mode = true,
    --         -- callback for what to do with the url
    --         action_callback = require("gitlinker.actions").copy_to_clipboard,
    --         -- print the url after performing the action
    --         print_url = false,
    --         -- mapping to call url generation
    --         mappings = "<leader>gy",
    --       },
    --     }
    --   end,
    --   dependencies = "nvim-lua/plenary.nvim",
    -- },
    -- {
    --   "sindrets/diffview.nvim",
    --   event = "BufRead",
    -- },

    {
      "tpope/vim-fugitive",
      cmd = {
        "G",
        "Git",
        "Gdiffsplit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GDelete",
        "GBrowse",
        "GRemove",
        "GRename",
        "Glgrep",
        "Gedit"
      },
      ft = { "fugitive" }
    },

    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
    {
      "mg979/vim-visual-multi",
      branch = "master",
      config = function()
        vim.cmd [[
        let g:VM_theme = 'nord'

        let g:VM_maps = {}
        let g:VM_maps['Add Cursor Down'] = '<C-j>'
        let g:VM_maps['Add Cursor Up'] = '<C-k>'

        let g:VM_mouse_mappings = 1

        let g:VM_Mono_hl   = 'DiffChange'
        let g:VM_Extend_hl = 'DiffAdd'
        let g:VM_Cursor_hl = 'Visual'
        let g:VM_Insert_hl = 'DiffChange'

        let g:VM_highlight_matches = 'underline'
      ]]
      end,
    },
    {
      "danymat/neogen",
      cmd = "Neogen",
      config = function()
        require('neogen').setup {}
      end,
      dependencies = "nvim-treesitter/nvim-treesitter",
      -- Uncomment next line if you want to follow only stable versions
      -- tag = "*"
    },
    {
      "AckslD/nvim-neoclip.lua",
     enabled =false,
      dependencies = {
        { 'kkharji/sqlite.lua',
          module = 'sqlite'
        },
        -- you'll need at least one of these
        { 'nvim-telescope/telescope.nvim' },
        -- {'ibhagwan/fzf-lua'},
      },
      config = function()
        require('neoclip').setup(
          {
            history = 1000,
            enable_persistent_history = true,
            length_limit = 1048576,
            continuous_sync = false,
            db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
            filter = nil,
            preview = true,
            default_register = '"',
            default_register_macros = 'q',
            enable_macro_history = true,
            content_spec_column = false,
            on_paste = {
              set_reg = false,
            },
            on_replay = {
              set_reg = false,
            },
            keys = {
              telescope = {
                i = {
                  select = '<cr>',
                  paste = '<c-.>',
                  paste_behind = '<c-,>',
                  replay = '<c-q>', -- replay a macro
                  delete = '<c-d>', -- delete an entry
                  custom = {},
                },
                n = {
                  select = '<cr>',
                  paste = 'p',
                  --- It is possible to map to more than one key.
                  -- paste = { 'p', '<c-p>' },
                  paste_behind = 'P',
                  replay = 'q',
                  delete = 'd',
                  custom = {},
                },
              },
              fzf = {
                select = 'default',
                -- paste = 'ctrl-p',
                -- paste_behind = 'ctrl-k',
                custom = {},
              },
            },
          }
        )
      end,
    },
    {
      'kosayoda/nvim-lightbulb',
      dependencies = 'antoinemadec/FixCursorHold.nvim',
      config = function()
        require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
      end
    },

    -- {
    --   'simrat39/rust-tools.nvim',
    --   dependencies = 'neovim/nvim-lspconfig',
    --   config = function()

    --     local rt = require("rust-tools")
    --     rt.setup({
    --       server = {
    --         on_attach = function(_, bufnr)
    --           -- Hover actions
    --           vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --           -- Code action groups
    --            vim.keymap.set("n", "ga", rt.code_action_group.code_action_group, { buffer = bufnr })
    --         end,
    --       },
    --     })
    --   end
    -- },

    -- {
    --   "SmiteshP/nvim-navic",
    --   dependencies = "neovim/nvim-lspconfig"
    -- },
  }
end


return M
