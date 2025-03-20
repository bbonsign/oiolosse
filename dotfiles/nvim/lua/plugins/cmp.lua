return {
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    -- build = vim.g.lazyvim_blink_main and "cargo build --release",
    -- build = vim.g.lazyvim_blink_main and "nix run .#build-plugin",
    opts = {
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        -- use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",
        kind_icons = {
          Text = "󰉿 ",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓 ",

          Field = "󰜢 ",
          Variable = "󰆦 ",
          Property = "󰖷 ",

          Class = "󱡠 ",
          Interface = "󱡠 ",
          Struct = "󱡠 ",
          Module = "󰅩 ",

          Unit = "󰪚 ",
          Value = " ",
          Enum = " ",
          EnumMember = " ",

          Keyword = "󰻾",
          Constant = "󰏿",

          Snippet = " ",
          Color = "󰏘 ",
          File = "󰈔",
          Reference = "󰬲 ",
          Folder = "󰉋 ",
          Event = "󱐋",
          Operator = "󰪚 ",
          TypeParameter = "󰬛 ",
        },
      },
      completion = {
        list = {
          selection = { auto_insert = true, preselect = false },
        },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          border = "rounded",
          winblend = 10,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
          window = {
            border = "rounded",
          },
        },
        -- ghost_text = {
        --   enabled = vim.g.ai_cmp,
        -- },
      },

      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them with blink.compat
        -- compat = {},
        default = { "lsp", "path", "snippets", "buffer", "markdown" },
        providers = {
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            fallbacks = { "lsp" },
          },
        },
      },

      keymap = {
        preset = "enter",
        ["<Esc>"] = {},
        ["<C-c>"] = { "cancel", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev" },
        ["<C-j>"] = { "show", "select_next" },
        ["<C-y>"] = { "select_and_accept" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        },
      },
      cmdline = {
        enabled = true,
        completion = {
          ghost_text = { enabled = false },
        },
        -- By default, we choose providers for the cmdline based on the current cmdtype
        -- You may disable cmdline completions by replacing this with an empty table
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" then
            return { "cmdline" }
          end
          return {}
        end,
        keymap = {
          preset = "enter",
          -- ["<Esc>"] = { "cancel", "fallback" },
          ["<C-c>"] = { "cancel", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "show", "select_next", "fallback" },
          ["<C-y>"] = { "select_accept_and_enter" },
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
