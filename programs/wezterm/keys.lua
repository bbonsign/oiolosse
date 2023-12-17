local wezterm = require 'wezterm'
local act     = wezterm.action
local keys    = {
  -- Send "CTRL-X" to the terminal when pressing CTRL-X, CTRL-X
  {
    key = 'x',
    mods = 'LEADER|CTRL',
    action = act.SendKey { key = 'x', mods = 'CTRL' },
  },

  { key = 't', mods = 'LEADER|SHIFT', action = act.ReloadConfiguration, },
  -- Activate Key Tables
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'window_mode',
      one_shot = false,
    },
  },
  {
    key = 'a',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'activate_pane',
      one_shot = false,
    },
  },
  {
    key = '/',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'quick_select',
      one_shot = false,
    },
  },
  {
    key = 'v',
    mods = 'LEADER|CTRL',
    action = act.ActivateCopyMode,
  },

  -- Splits, aka Panes
  { key = ',', mods = 'LEADER', action = act.PaneSelect },
  {
    key = 'v',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'Enter',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 's',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  {
    key = 'h',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Navigate
  { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'h', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Left' },

  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'l', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Right' },

  { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'k', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Up' },

  { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'j', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Down' },

  { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(-1) },

  -- Tabs
  { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain', },
  { key = 't', mods = 'LEADER|CTRL', action = act.SpawnTab 'CurrentPaneDomain', },
  { key = '{', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1) },

  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState, },

}

-- LEADER + number to activate that tab
for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

return {
  debug_key_events = true,
  -- timeout_milliseconds defaults to 1000 and can be omitted
  leader = { key = 'x', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = keys,

  key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
      { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

      { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

      { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

      { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    activate_pane = {
      { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
      { key = 'h', action = act.ActivatePaneDirection 'Left' },

      { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
      { key = 'l', action = act.ActivatePaneDirection 'Right' },

      { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
      { key = 'k', action = act.ActivatePaneDirection 'Up' },

      { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
      { key = 'j', action = act.ActivatePaneDirection 'Down' },

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },

    window_mode = {
      { key = 'r',
        action = act.ActivateKeyTable {
          name = 'resize_pane',
          one_shot = false,
        },
      },
      { key = ',', action = act.PaneSelect },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },
    -- Quick searches
    quick_select = {
      {
        -- default QuickSelect patterns
        key = '/',
        action = act.QuickSelect,
      },

      {
        -- match urls
        key = 'u',
        action = act.QuickSelectArgs {
          patterns = {
            'https?://\\S+',
          },
        },
      },
      {
        -- match things that look like sha1 hashes
        key = 'h',
        action = act.QuickSelectArgs {
          patterns = {
            '[0-9a-f]{7,40}',
          },
        },
      },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },
  },
}
