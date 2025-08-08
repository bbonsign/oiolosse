return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- see above keymap to toggle inlay_hints
      inlay_hints = { enabled = false },

      -- options for vim.diagnostic.config()
      diagnostics = {
        -- virtual_text = true,
        virtual_text = false,
        float = {
          -- focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },

      setup = {

        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },

      servers = {
        lua_ls = {
          mason = false,
        },
        yamlls = {
          settings = {
            yaml = {
              -- used in cloudformation yamls
              customTags = {
                "!GetAtt",
                "!Ref",
                "!Sub",
              },
            },
          },
        },
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Using Ruff
              disableTaggedHints = true,
            },
            python = {
              analysis = {
                -- ignore = { "*" }, -- Using Ruff
                -- typeCheckingMode = "off", -- Using mypy
              },
            },
          },
        },
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
        emmet_ls = {
          filetypes = {
            "html",
            -- "elixir",
            "heex",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "javascript",
            "typescript",
            -- "markdown",
          },
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L26
                ["bem.enabled"] = true,
              },
            },
          },
        },
        -- tailwindcss = {
        --   -- exclude a filetype from the default_config
        --   -- filetypes_exclude = { "markdown" },
        --   -- add additional filetypes to the default_config
        --   filetypes_include = { "elixir", "heex" },
        --   -- to fully override the default_config, change the below
        --   -- filetypes = {}
        -- },
        rust_analyzer = {
          settings = {
            diagnostics = {
              virtual_text = true,
            },
          },
        },
        -- snyk_ls = {
        --   filetypes = {
        --     "toml",
        --     "requirements",
        --   },
        --   init_options = {
        --     activateSnykCode = "true",
        --     -- token = os.getenv("SNYK_TOKEN"),
        --   },
        -- },
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.diagnostics.fish,
        },
      }
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        lua = { "stylua" },
        fish = { "fish_indent" },
        python = { "ruff_organize_imports", "ruff_format" },
        nu = { "topiary_nu" },
        -- -- You can customize some of the format options for the filetype (:help conform.format)
        -- rust = { "rustfmt", lsp_format = "fallback" },
        -- -- Conform will run the first available formatter
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      formatters = {
        topiary_nu = {
          command = "topiary",
          args = { "format", "--language", "nu" },
        },
      },
    },
  },

  -- See above for other lspconfig
  {
    "neovim/nvim-lspconfig",
    -- https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      local format = function()
        require("lazyvim.util").format({ force = true })
      end

      keys[#keys + 1] = {
        "<leader>lf",
        format,
        desc = "Format Document",
      }

      keys[#keys + 1] = {
        "<leader>lr",
        vim.lsp.buf.rename,
        desc = "Rename",
        has = "rename",
      }

      keys[#keys + 1] = {
        "<leader>la",
        vim.lsp.buf.code_action,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      }

      keys[#keys + 1] = {
        "<leader>lA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
        has = "codeAction",
      }

      keys[#keys + 1] = {
        "<leader>li",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,
        desc = "Toggle Inlay Hints",
        mode = { "n", "v" },
        has = "inlay",
      }
      -- disable a keymap
      -- keys[#keys + 1] = { "K", false }
      keys[#keys + 1] = {
        "<leader>hh",
        vim.lsp.buf.hover,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "<leader>lh",
        vim.lsp.buf.hover,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "<leader>lk",
        vim.lsp.buf.hover,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "<leader>ch",
        vim.lsp.buf.hover,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "<leader>ck",
        vim.lsp.buf.hover,
        desc = "Hover",
      }

      keys[#keys + 1] = {
        "<leader>lI",
        "<Cmd>LspInfo<CR>",
        desc = "LspInfo",
      }
      keys[#keys + 1] = {
        "<leader>lL",
        "<Cmd>LspLog<CR>",
        desc = "LspLog",
      }
      -- Defined in ../config/keymaps.lua
      -- keys[#keys + 1] = {
      --   "<leader>ls",
      --   "<Cmd>Outline<CR>",
      --   desc = "LspStop",
      -- }
      keys[#keys + 1] = {
        "<leader>lS",
        "<Cmd>LspStop<CR>",
        desc = "LspStop",
      }
      keys[#keys + 1] = {
        "<leader>lR",
        "<Cmd>LspRestart<CR>",
        desc = "LspRestart",
      }
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.ui = { border = "single" }
      return opts
    end,
  },
}
