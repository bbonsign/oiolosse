vim.pack.add({
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/moyiz/blink-emoji.nvim" },
  { src = "https://github.com/disrupted/blink-cmp-conventional-commits" },
})

local cmp = require("blink.cmp")

-- cmp.build():pwait()

cmp.setup({
  fuzzy = {
    implementation = "prefer_rust",
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
  },

  sources = {
    -- adding any nvim-cmp sources here will enable them with blink.compat
    -- compat = {},
    default = { "lsp", "path", "snippets", "buffer", "markdown" },
    per_filetype = {
      -- sql = { "lsp", "dadbod", "path", "snippets", "buffer", "markdown" },
      sql = { "lsp", "path", "snippets", "buffer", "markdown" },
      gitcommit = { "conventional_commits", "emoji", "lsp", "path", "snippets", "buffer" },
      jjdescription = { "conventional_commits", "emoji", "lsp", "path", "snippets", "buffer" },
      markdown = { "lsp", "path", "emoji", "snippets", "markdown", "buffer" },
      codecompanion = { "codecompanion" },
    },
    providers = {
      -- dadbod = {
      --   name = "Dadbod",
      --   module = "vim_dadbod_completion.blink",
      --   opts = {
      --     vim_dadbod_completion_lowercase_keywords = 1,
      --   },
      -- },
      markdown = {
        name = "RenderMarkdown",
        module = "render-markdown.integ.blink",
        fallbacks = { "lsp" },
      },
      emoji = {
        module = "blink-emoji",
        name = "Emoji",
        -- score_offset = 15, -- Tune by preference
        opts = {
          insert = true, -- Insert emoji (default) or complete its name
          ---@type string|table|fun():table
          trigger = function()
            return { ":" }
          end,
        },
        should_show_items = function()
          return vim.tbl_contains(
            -- Enable emoji completion only for git commits and markdown.
            -- By default, enabled for all file-types.
            { "jjdescription", "gitcommit", "markdown" },
            vim.o.filetype
          )
        end,
      },
      conventional_commits = {
        name = "Conventional Commits",
        module = "blink-cmp-conventional-commits",
        enabled = function()
          return vim.bo.filetype == "gitcommit" or vim.bo.filetype == "jjdescription"
        end,
        opts = {}, -- none so far
      },
    },
  },

  keymap = {
    preset = "enter",
    ["<Esc>"] = {},
    ["<C-c>"] = { "cancel", "fallback" },
    ["<Up>"] = { "select_prev" },
    ["<Down>"] = { "select_next" },
    ["<C-k>"] = { "select_prev" },
    ["<C-j>"] = { "show", "select_next" },
    ["<C-y>"] = { "select_and_accept" },
    ["<CR>"] = { "select_and_accept", "fallback" },
    -- ["<Tab>"] = {
    --   LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
    --   "fallback",
    -- },
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
})
