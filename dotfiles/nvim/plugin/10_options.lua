-- stylua: ignore start

-- General ====================================================================

local opt = vim.opt

opt.mouse       = 'a'            -- Enable mouse
-- opt.mousescroll = 'ver:25,hor:6' -- Customize mouse scroll
opt.undofile    = true           -- Enable persistent undo

opt.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- UI =========================================================================
opt.breakindent    = true       -- Indent wrapped lines to match line start
opt.breakindentopt = 'list:-1'  -- Add padding for lists (if 'wrap' is set)
opt.colorcolumn    = '+1'       -- Draw column on the right of maximum width
opt.cmdheight      = 1          -- Only show cmdline when in use
opt.cursorline     = true       -- Enable current line highlighting
opt.linebreak      = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
opt.list           = true       -- Show helpful text indicators
opt.number         = false      -- Show line numbers
opt.pumborder      = 'single'   -- Use border in popup menu
opt.pumheight      = 10         -- Make popup menu smaller
opt.pummaxwidth    = 100        -- Make popup menu not too wide
opt.ruler          = false      -- Don't show cursor coordinates
opt.shortmess      = 'CFOSWaco' -- Disable some built-in completion messages
opt.showmode       = false      -- Don't show mode in command line
opt.signcolumn     = 'yes'      -- Always show signcolumn (less flicker)
opt.splitbelow     = true       -- Horizontal splits will be below
opt.splitkeep      = 'screen'   -- Reduce scroll during window split
opt.splitright     = true       -- Vertical splits will be to the right
opt.winborder      = 'rounded'  -- Use border in floating windows
opt.wrap           = false      -- Don't visually wrap lines

opt.cursorlineopt  = 'screenline,number' -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
opt.fillchars = 'eob: ,fold:╌'
opt.listchars = 'extends:…,nbsp:␣,precedes:…,tab:> '

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
opt.foldlevel   = 10       -- Fold nothing by default; set to 0 or 1 to fold
opt.foldmethod  = 'indent' -- Fold based on indent level
opt.foldnestmax = 10       -- Limit number of fold levels
opt.foldtext    = ''       -- Show text under fold with its highlighting

-- Editing ====================================================================
opt.autoindent    = true    -- Use auto indent
opt.expandtab     = true    -- Convert tabs to spaces
opt.formatoptions = 'rqnl1j'-- Improve comment editing
opt.ignorecase    = true    -- Ignore case during search
opt.incsearch     = true    -- Show search matches while typing
opt.infercase     = true    -- Infer case in built-in completion
opt.shiftwidth    = 2       -- Use this number of spaces for indentation
opt.smartcase     = true    -- Respect case if search pattern has upper case
opt.smartindent   = true    -- Make indenting smart
opt.spelloptions  = 'camel' -- Treat camelCase word parts as separate words
opt.tabstop       = 2       -- Show tab as this number of spaces
opt.virtualedit   = 'block' -- Allow going past end of line in blockwise mode

opt.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
opt.complete        = '.,w,b,kspell'                  -- Use less sources
opt.completeopt     = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior
opt.completetimeout = 100                             -- Limit sources delay

-- From LazyVim ===============================================================
opt.autowrite = true                                            -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"  -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2                                            -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true                                              -- Confirm to save changes before exiting modified buffer
opt.cursorline = true                                           -- Enable highlighting of the current line
opt.expandtab = true                                            -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatexpr = "v:lua.LazyVim.format.formatexpr()"
opt.formatoptions = "jcroqlnt"                                  -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true       -- Ignore case
opt.inccommand = "nosplit"  -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3          -- global statusline
opt.linebreak = true        -- Wrap lines at convenient points
opt.list = true             -- Show some invisible characters (tabs...
opt.mouse = "a"             -- Enable mouse modeH
opt.pumblend = 10           -- Popup blend
opt.pumheight = 10          -- Maximum number of entries in a popup
opt.relativenumber = false   -- Relative line numbers
opt.ruler = false           -- Disable the default ruler
opt.scrolloff = 4           -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true       -- Round indent
opt.shiftwidth = 2          -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false                           -- Dont show mode since we have a statusline
opt.sidescrolloff = 8                          -- Columns of context
opt.signcolumn = "yes"                         -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true                           -- Don't ignore case with capitals
opt.smartindent = true                         -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true                          -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true                          -- Put new windows right of current
-- opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]
opt.tabstop = 2                                -- Number of spaces tabs count for
opt.termguicolors = true                       -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300  -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200                           -- Save swap file and trigger CursorHold
opt.virtualedit = "block"                      -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full"             -- Command-line completion mode
opt.winminwidth = 5                            -- Minimum window width
opt.wrap = false                               -- Disable line wrap

-- From old config
opt.textwidth = 100
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false


-- Diagnostics ================================================================

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
-- See `:h vim.diagnostic` and `:h vim.diagnostic.config()`.
local diagnostic_opts = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },

  -- Show all diagnostics as underline (for their messages type `<Leader>ld`)
  underline = { severity = { min = 'HINT', max = 'ERROR' } },

  -- Show more details immediately for errors on the current line
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,

  -- When jumping to a diagnostic (e.g. `]d`/`[d`), also show it in a float,
  -- as if pressing `<C-w>d` after the jump.
  jump = {
    on_jump = function(diagnostic, bufnr)
      if not diagnostic then return end
      vim.diagnostic.open_float(bufnr, { scope = 'cursor', focus = false })
    end,
  },
}

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
Config.later(function() vim.diagnostic.config(diagnostic_opts) end)

-- stylua: ignore end
