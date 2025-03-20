local set_layout = function(layout)
  Snacks.picker.get()[1]:set_layout(layout)
end

return {
  formatters = {
    file = {
      -- filename_first = false, -- display filename before the file path
      truncate = 60, -- truncate the file path to (roughly) this length
      -- filename_only = false, -- only show the filename
      -- icon_width = 2, -- width of the icon (in characters)
      -- git_status_hl = true, -- use the git status highlight group for the filename
    },
  },
  layout = {
    preset = "ivy",
    layout = {
      title_pos = "center",
    },
  },
  win = {
    -- input window
    input = {
      keys = {
        -- to close the picker on ESC instead of going to normal mode,
        -- add the following keymap to your config
        -- ["<Esc>"] = { "close", mode = { "n", "i" } },
        ["/"] = "toggle_focus",
        ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
        ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
        ["<C-c>"] = { "close", mode = "i" },
        ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
        ["<CR>"] = { "confirm", mode = { "n", "i" } },
        ["<Down>"] = { "list_down", mode = { "i", "n" } },
        ["<Esc>"] = "close",
        ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
        ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
        ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
        ["<Up>"] = { "list_up", mode = { "i", "n" } },
        ["<A-d>"] = { "inspect", mode = { "n", "i" } },
        ["<A-f>"] = { "toggle_follow", mode = { "i", "n" } },
        ["<A-h>"] = { "toggle_hidden", mode = { "i", "n" } },
        ["<A-i>"] = { "toggle_ignored", mode = { "i", "n" } },
        ["<A-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-z>p"] = { "focus_preview", mode = { "i", "n" } },
        ["<C-z><C-p>"] = { "focus_preview", mode = { "i", "n" } },
        ["<C-z>m"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-z><C-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-space>"] = { "toggle_preview", mode = { "i", "n" } },
        ["<A-w>"] = { "cycle_win", mode = { "i", "n" } },
        ["<C-a>"] = { "select_all", mode = { "n", "i" } },
        -- ["<C-u>"] = { "list_scroll_up", mode = { "i", "n" } },
        -- ["<C-d>"] = { "list_scroll_down", mode = { "i", "n" } },
        ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
        ["<C-g>"] = { "toggle_live", mode = { "i", "n" } },
        ["<C-j>"] = { "list_down", mode = { "i", "n" } },
        ["<C-k>"] = { "list_up", mode = { "i", "n" } },
        ["<C-n>"] = { "list_down", mode = { "i", "n" } },
        ["<C-p>"] = { "list_up", mode = { "i", "n" } },
        ["<C-q>"] = { "qflist", mode = { "i", "n" } },
        ["<C-s>"] = { "edit_split", mode = { "i", "n" } },
        ["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
        ["<C-z>d"] = {
          function()
            set_layout("default")
          end,
          mode = { "i", "n" },
          desc = "layout_default",
        },
        ["<C-z><C-d>"] = {
          function()
            set_layout("default")
          end,
          mode = { "i", "n" },
          desc = "layout_default",
        },
        ["<C-z>h"] = { "layout_left", mode = { "i", "n" } },
        ["<C-z><C-h>"] = { "layout_left", mode = { "i", "n" } },
        ["<C-z>j"] = {
          function()
            set_layout("ivy")
          end,
          mode = { "i", "n" },
          desc = "layout_ivy",
        },
        ["<C-z><C-j>"] = {
          function()
            set_layout("ivy")
          end,
          mode = { "i", "n" },
          desc = "layout_ivy",
        },
        ["<C-z>k"] = { "layout_top", mode = { "i", "n" } },
        ["<C-z><C-k>"] = { "layout_top", mode = { "i", "n" } },
        ["<C-z>l"] = { "layout_right", mode = { "i", "n" } },
        ["<C-z><C-l>"] = { "layout_right", mode = { "i", "n" } },
        ["?"] = "toggle_help_input",
        ["G"] = "list_bottom",
        ["gg"] = "list_top",
        ["j"] = "list_down",
        ["k"] = "list_up",
        ["q"] = "close",
      },
    },
    -- result list window
    list = {
      keys = {
        ["/"] = "toggle_focus",
        ["<2-LeftMouse>"] = "confirm",
        ["<CR>"] = "confirm",
        ["<Down>"] = "list_down",
        ["<Esc>"] = "close",
        ["<S-CR>"] = { { "pick_win", "jump" } },
        ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
        ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
        ["<Up>"] = "list_up",
        ["<A-d>"] = "inspect",
        ["<A-f>"] = "toggle_follow",
        ["<A-h>"] = "toggle_hidden",
        ["<A-i>"] = "toggle_ignored",
        ["<C-z>p"] = { "focus_preview", mode = { "i", "n" } },
        ["<C-z><C-p>"] = { "focus_preview", mode = { "i", "n" } },
        ["<A-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-z>m"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-z><C-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-space>"] = { "toggle_preview", mode = { "i", "n" } },
        ["<A-w>"] = "cycle_win",
        ["<C-a>"] = "select_all",
        -- ["<C-u>"] = "list_scroll_up",
        -- ["<C-d>"] = "list_scroll_down",
        ["<C-u>"] = "preview_scroll_up",
        ["<C-d>"] = "preview_scroll_down",
        ["<C-j>"] = "list_down",
        ["<C-k>"] = "list_up",
        ["<C-n>"] = "list_down",
        ["<C-p>"] = "list_up",
        ["<C-s>"] = "edit_split",
        ["<C-v>"] = "edit_vsplit",
        ["<C-z>d"] = {
          function()
            set_layout("default")
          end,
          mode = { "i", "n" },
          desc = "layout_default",
        },
        ["<C-z><C-d>"] = {
          function()
            set_layout("default")
          end,
          mode = { "i", "n" },
          desc = "layout_default",
        },
        ["<C-z>h"] = { "layout_left", mode = { "i", "n" } },
        ["<C-z><C-h>"] = { "layout_left", mode = { "i", "n" } },
        ["<C-z>j"] = {
          function()
            set_layout("ivy")
          end,
          mode = { "i", "n" },
          desc = "layout_ivy",
        },
        ["<C-z><C-j>"] = {
          function()
            set_layout("ivy")
          end,
          mode = { "i", "n" },
          desc = "layout_ivy",
        },
        ["<C-z>k"] = { "layout_top", mode = { "i", "n" } },
        ["<C-z><C-k>"] = { "layout_top", mode = { "i", "n" } },
        ["<C-z>l"] = { "layout_right", mode = { "i", "n" } },
        ["<C-z><C-l>"] = { "layout_right", mode = { "i", "n" } },
        ["?"] = "toggle_help_list",
        ["G"] = "list_bottom",
        ["gg"] = "list_top",
        ["i"] = "focus_input",
        ["j"] = "list_down",
        ["k"] = "list_up",
        ["q"] = "close",
        ["zb"] = "list_scroll_bottom",
        ["zt"] = "list_scroll_top",
        ["zz"] = "list_scroll_center",
      },
    },
    -- preview window
    preview = {
      keys = {
        ["<Esc>"] = false,
        ["q"] = "close",
        ["i"] = "focus_input",
        ["<ScrollWheelDown>"] = "list_scroll_wheel_down",
        ["<ScrollWheelUp>"] = "list_scroll_wheel_up",
        ["<A-w>"] = "cycle_win",
      },
    },
  },
}
