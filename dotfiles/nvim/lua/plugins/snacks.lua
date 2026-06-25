vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local snacks = require("snacks")
local logo = [[
                 _)
 __ \   _ \  _ \\ \   / | __ `__ \
 |   |  __/ (   |\ \ /  | |   |   |
_|  _|\___|\___/  \_/  _|_|  _|  _|
]]

local sessions = require("bb.sessions")

snacks.setup({
  styles = {
    blame_line = {
      width = 0.9,
      height = 0.6,
      border = "rounded",
      title = " Git Blame ",
      title_pos = "center",
      ft = "git",
    },
    zoom_indicator = {
      text = "▍ zoom   ▍",
      minimal = true,
      enter = false,
      focusable = false,
      height = 1,
      row = 0,
      col = 0,
      backdrop = false,
    },
  },
  animate = { enabled = false },
  bigfile = { enabled = true },
  explorer = {
    enabled = true,
    replace_netrw = false,
    trash = true,
  },
  notifier = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
    preset = {
      header = logo,
      keys = {
        { icon = " ", key = "s", desc = "Restore Session", action = sessions.restore },
        { icon = "󰍡 ", key = "m", desc = "Messages", action = ":messages" },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = "󰇥 ", key = "y", desc = "Yazi", action = ":Yazi" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = "󰝒 ", key = "n", desc = "New File", action = ":enew" },
        { icon = "󰚰 ", key = "u", desc = "Update Plugins", action = ":lua vim.pack.update()" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          if not in_git then
            return {
              { key = "S", action = function() end, hidden = true },
              { key = "G", action = function() end, hidden = true },
              { key = "J", action = function() end, hidden = true },
              { key = "b", action = function() end, hidden = true },
            }
          end
          return {
            {
              icon = " ",
              key = "S",
              desc = "Git Status Files",
              action = ":lua Snacks.dashboard.pick('git_status')",
            },
            { icon = " ", key = "G", desc = "Lazygit", action = ":lua Snacks.lazygit()" },
            { icon = " ", key = "J", desc = "JJUI", action = ":lua Snacks.terminal.toggle('jjui')" },
            { icon = " ", key = "b", desc = "Browse repo", action = ":lua Snacks.gitbrowse()" },
          }
        end,
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        {
          icon = "󰒲 ",
          key = "L",
          desc = "LazyVim Changelog",
          action = function()
            LazyVim.news.changelog()
          end,
          enabled = package.loaded.lazy ~= nil,
        },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        {
          icon = "󰒲 ",
          key = "x",
          desc = "LazyExtras",
          action = ":LazyExtras",
          enabled = package.loaded.lazy ~= nil,
        },
        { icon = " ", key = "M", desc = "Mason", action = ":Mason" },
        { icon = "", key = "h", desc = "Help Docs", action = ":lua Snacks.dashboard.pick('help')" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
  },
  debug = { enabled = true },
  git = { enabled = true },
  image = {
    -- resolve = function(path, src)
    --   if require("obsidian.api").path_is_note(path) then
    --     return require("obsidian.api").resolve_image_path(src)
    --   end
    -- end,
  },
  indent = { enabled = false },
  input = { enabled = true },
  lazygit = { enabled = true },
  scoll = { enabled = false },
  scratch = { enabled = false },
  toggle = { enabled = true },
  picker = require("bb.snacks_picker"),
  terminal = {
    shell = "nu",
    win = {
      border = "double",
    },
  },
  words = { enabled = true }, -- illuminate lsp references
  zen = {
    show = {
      statusline = true,
      tabline = true,
    },
  },
})

vim.keymap.set("n", "<leader>qs", sessions.save, { desc = "Save session (cwd)" })
vim.keymap.set("n", "<leader>ql", sessions.restore, { desc = "Restore session (cwd)" })

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
  :map("<leader>uc")
Snacks.toggle
  .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
  :map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- stylua: ignore start
-- lazygit
if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set(
    "n",
    "<leader>gg",
    function()
      Snacks.lazygit({ cwd = Snacks.git.get_root() })
    end,
    { desc = "Lazygit (Root Dir)" }
  )
  vim.keymap.set(
    "n",
    "<leader>gG",
    Snacks.lazygit.open,
    { desc = "Lazygit (cwd)" }
  )
end

vim.keymap.set(
  "n",
  "<leader>gL",
  Snacks.lazygit.log_file,
  { desc = "Lazygit Log File" }
)

vim.keymap.set(
  "n",
  "<leader>gb",
  Snacks.picker.git_log_line,
  { desc = "Git Blame Line" }
)

vim.keymap.set(
  "n",
  "<leader>gf",
  Snacks.picker.git_log_file,
  { desc = "Git Current File History" }
)

vim.keymap.set(
  "n",
  "<leader>gl",
  function()
    Snacks.picker.git_log(
      { cwd = Snacks.git.get_root() }
    )
  end,
  { desc = "Git Log" }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>gB",
  Snacks.gitbrowse.open,
  { desc = "Git Browse (open)" }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>gY",
  function()
    Snacks.gitbrowse({
      open = function(url) vim.fn.setreg("+", url) end,
      notify = false,
    })
  end,
  { desc = "Git Browse (copy)" }
)

vim.keymap.set(
  { "n", "t" },
  "<c-/>",
  Snacks.terminal.focus,
  { desc = "Terminal (Root Dir)" }
)

vim.keymap.set(
  "n",
  "<leader>.",
  Snacks.picker.buffers,
  { desc = "Buffers" }
)

vim.keymap.set(
  "n",
  "<leader>:",
  Snacks.picker.commands,
  { desc = "Commands" }
)

vim.keymap.set(
  "n",
  "<leader>/",
  function()
    Snacks.picker.grep({ root = false })
  end,
  { desc = "Grep (cwd)" }
)

vim.keymap.set(
  "n",
  '<leader>"',
  Snacks.picker.registers,
  { desc = "Registers" }
)

vim.keymap.set(
  "n",
  "<leader>'",
  function() Snacks.picker.resume() end,
  { desc = "Resume" }
)

vim.keymap.set(
  "n",
  "<leader><BS>",
  Snacks.notifier.hide,
  { desc = "Dismiss all Notifications" }
)

vim.keymap.set(
  "n",
  "<leader>s=",
  Snacks.picker.spelling,
  { desc = "Spelling" }
)

vim.keymap.set(
  "n",
  "<leader>bb",
  Snacks.picker.buffers,
  { desc = "Buffers" }
)

vim.keymap.set(
  "n",
  "<leader>bs",
  Snacks.picker.buffers,
  { desc = "Buffers" }
)

vim.keymap.set(
  "n",
  "<leader>sD",
  Snacks.picker.diagnostics,
  { desc = "Diagnostics" }
)

vim.keymap.set(
  "n",
  "<leader>sd",
  Snacks.picker.diagnostics_buffer,
  { desc = "Buffer Diagnostics" }
)

vim.keymap.set(
  "n",
  "<leader>sG",
  function()
    Snacks.picker.grep({
      cwd = Snacks.git.get_root(),
    })
  end,
  { desc = "Grep (Root Dir)" }
)

vim.keymap.set(
  "n",
  "<leader>sg",
  function()
    Snacks.picker.grep({ root = false })
  end,
  { desc = "Grep (cwd)" }
)

vim.keymap.set(
  "n",
  "<leader>sh",
  Snacks.picker.help,
  { desc = "Grep (cwd)" }
)


vim.keymap.set(
  "n",
  "<leader>sp",
  Snacks.picker.pickers,
  { desc = "Pickers" }
)

vim.keymap.set(
  "n",
  "<leader>sr",
  Snacks.picker.resume,
  { desc = "Resume" }
)

vim.keymap.set("n", "<leader>E", Snacks.explorer.open, {desc = "Notification History" })
vim.keymap.set("n", "<leader>n", Snacks.picker.notifications, {desc = "Notification History" })
vim.keymap.set("n", "<leader>fg", Snacks.picker.git_files, {desc = "Find Files (git-files)" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, {desc = "Recent (cwd)" })
vim.keymap.set("n", "<leader>gd", Snacks.picker.git_diff, {desc = "Git Diff (hunks)" })
vim.keymap.set("n", "<leader>gD", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, {desc = "Git Diff (origin)" })
vim.keymap.set("n", "<leader>js", Snacks.picker.git_status, {desc = "Git Status" })
vim.keymap.set("n", "<leader>gs", Snacks.picker.git_status, {desc = "Git Status" })
vim.keymap.set("n", "<leader>sb", Snacks.picker.lines, {desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", Snacks.picker.grep_buffers, {desc = "Grep Open Buffers" })
vim.keymap.set("n", '<leader>s"', Snacks.picker.registers, {desc = "Registers" })
vim.keymap.set("n", '<leader>s/', Snacks.picker.search_history, {desc = "Search History" })
vim.keymap.set("n", "<leader>sa", Snacks.picker.autocmds, {desc = "Autocmds" })
vim.keymap.set("n", "<leader>sc", Snacks.picker.command_history, {desc = "Command History" })
vim.keymap.set("n", "<leader>sC", Snacks.picker.commands, {desc = "Commands" })
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics, {desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics_buffer, {desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sh", Snacks.picker.help, {desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", Snacks.picker.highlights, {desc = "Highlights" })
vim.keymap.set("n", "<leader>si", Snacks.picker.icons, {desc = "Icons" })
vim.keymap.set("n", "<leader>sj", Snacks.picker.jumps, {desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, {desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", Snacks.picker.loclist, {desc = "Location List" })
vim.keymap.set("n", "<leader>sM", Snacks.picker.man, {desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", Snacks.picker.marks, {desc = "Marks" })
vim.keymap.set("n", "<leader>sR", Snacks.picker.resume, {desc = "Resume" })
vim.keymap.set("n", "<leader>sq", Snacks.picker.qflist, {desc = "Quickfix List" })
vim.keymap.set("n", "<leader>su", Snacks.picker.undo, {desc = "Undotree" })
vim.keymap.set("n", "<leader>uC", Snacks.picker.colorschemes, {desc = "Colorschemes" })

vim.keymap.set(
  { "n", "x" },
  "<leader>sW",
  function()
    Snacks.picker.grep_word({ root = false })
  end,
  { desc = "Visual selection or word (cwd)" }
)

-- Same as `Snacks.picker.grep_word` but adds "\b" regex word boudaries to the
vim.keymap.set(
  { "n", "x" },
  "<leader>sw",
  function()
    Snacks.picker.pick(
      "grep",
      {
        root = false,
        format = "file",
        live = false,
        supports_live = true,
        search = function(p)
          local word = p.visual and p.visual.text or vim.fn.expand("<cword>")
          local wordb = string.format("\\b%s\\b", word)
          return wordb
        end,
      }
    )
  end,
  { desc = "Visual selection or word (cwd)" }
)

vim.keymap.set(
  "n",
  "<leader>ud",
   Snacks.dashboard.open,
  { desc = "Dashboard" }
)
