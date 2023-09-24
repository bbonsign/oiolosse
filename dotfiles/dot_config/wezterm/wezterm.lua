local wezterm = require 'wezterm'
local fonts = require 'fonts'
local keys = require 'keys'

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

local config = {
  color_scheme = 'tokyonight',
  -- window_background_image = '/home/bbonsign/Pictures/Wallpapers/mountain-unsplash-6-small.jpg',
  -- text_background_opacity = 1.0,
  window_background_opacity = 0.8,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.5,
  },

  -- padding values in pixels
  window_padding = {
    left = 4,
    right = 0,
    top = 2,
    bottom = 0,
  },

  enable_kitty_keyboard = true,
   enable_scroll_bar = true,
}

for k, v in pairs(fonts) do
  config[k] = v
end

for k, v in pairs(keys) do
  config[k] = v
end
return config
