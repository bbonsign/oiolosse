-- state of listing details or not in ["gd"] keybind
local detail = false

-- helper function to parse output
local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
      -- Remove trailing slash
      line = line:gsub("/$", "")
      ret[line] = true
    end
  end
  return ret
end

-- build git status cache
local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        {
          cwd = key,
          text = true,
        }
      )
      local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
        cwd = key,
        text = true,
      })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }

      rawset(self, key, ret)
      return ret
    end,
  })
end

vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

-- Clear git status cache on refresh
local git_status = new_git_status()
local actions = require("oil.actions")
local refresh = actions.refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
  git_status = new_git_status()
  orig_refresh(...)
end

local setup_opts = {
  delete_to_trash = true,
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
  use_default_keymaps = false,
  columns = {
    "icon",
    -- "permissions",
    "size",
    -- "mtime",
  },
  confirmation = { border = "rounded" },
  view_options = {
    is_hidden_file = function(name, bufnr)
      local dir = require("oil").get_current_dir(bufnr)
      local is_dotfile = vim.startswith(name, ".") and name ~= ".."
      -- if no local directory (e.g. for ssh connections), just hide dotfiles
      if not dir then
        return is_dotfile
      end
      -- dotfiles are considered hidden unless tracked
      if is_dotfile then
        return not git_status[dir].tracked[name]
      else
        -- Check if file is gitignored
        return git_status[dir].ignored[name]
      end
    end,
  },
  keymaps = {
    q = "actions.close",
    ["?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["l"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["g."] = "actions.toggle_hidden",
    ["<leader>:"] = {
      "actions.open_cmdline",
      opts = {
        shorten_path = true,
        modify = ":h",
      },
      desc = "Open the command line with the current directory as an argument",
    },
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
  },
  preview = {
    win_options = {
      winblend = 50,
    },
  },
}

require("oil").setup(setup_opts)

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
