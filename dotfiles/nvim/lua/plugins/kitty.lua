-- return early if kitty isn't installed, e.g. on a server
if vim.fn.executable("kitten") == 0 then
  return
end

-- These globals must be set before `add()` sources the plugin's `plugin/`
-- files. `no_mappings` prevents the default <C-h/j/k/l> maps from being created.
vim.g.kitty_navigator_enable_stack_layout = 1
vim.g.kitty_navigator_no_mappings = 1

vim.pack.add({ "https://github.com/knubie/vim-kitty-navigator" })

vim.keymap.set({ "n", "v" }, "<A-h>", "<Cmd>KittyNavigateLeft<CR>", { silent = true, desc = "Navigate left (kitty)" })
vim.keymap.set({ "n", "v" }, "<A-j>", "<Cmd>KittyNavigateDown<CR>", { silent = true, desc = "Navigate down (kitty)" })
vim.keymap.set({ "n", "v" }, "<A-k>", "<Cmd>KittyNavigateUp<CR>", { silent = true, desc = "Navigate up (kitty)" })
vim.keymap.set({ "n", "v" }, "<A-l>", "<Cmd>KittyNavigateRight<CR>", { silent = true, desc = "Navigate right (kitty)" })

-- vim-kitty-navigator: seamless navigation between Neovim and kitty splits ====
Config.later(function()
  -- Build step (lazy.nvim `build = "cp ./*.py ~/.config/kitty/"`): copy the
  -- kitten python scripts into kitty's config dir after install/update so kitty
  -- can talk to the navigator. `ev.path` is the plugin's install directory.
  local kitty_build = function(env)
    vim.system({ "sh", "-c", "cp ./*.py ~/.config/kitty/" }, { cwd = env.path })
  end
  Config.on_packchanged(
    "vim-kitty-navigator",
    { "install", "update" },
    kitty_build,
    "Copy vim-kitty-navigator scripts to ~/.config/kitty"
  )
end)

-- vim-kitty: syntax highlighting for kitty.conf (load on first kitty filetype)
-- vim.pack.add({ "https://github.com/fladson/vim-kitty" })
