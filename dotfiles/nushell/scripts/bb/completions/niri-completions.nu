def "nu-complete niri" [] {
  [
    {value: msg description: "Communicate with the running niri instance"}
    {value: validate description: "Validate the config file"}
    {value: panic description: "Cause a panic to check if the backtraces are good"}
    {value: help description: "Print this message or the help of the given subcommand(s)"}
  ]
}

def "nu-complete niri msg" [] {
  [
    {value: outputs description: "List connected outputs"}
    {value: workspaces description: "List workspaces"}
    {value: windows description: "List open windows"}
    {value: layers description: "List open layer-shell surfaces"}
    {value: keyboard-layouts description: "Get the configured keyboard layouts"}
    {value: focused-output description: "Print information about the focused output"}
    {value: focused-window description: "Print information about the focused window"}
    # {value: action description: "Perform an action"}
    {value: output description: "Change output configuration temporarily"}
    {value: event-stream description: "Start continuously receiving events from the compositor"}
    {value: version description: "Print the version of the running niri instance"}
    {value: request-error description: "Request an error from the running niri instance"}
    {value: help description: "Print this message or the help of the given subcommand(s)"}
  ]
}

def "nu-complete niri msg action" [] {
  [
    {value: "quit" description: "Exit niri"}
    {value: "power-off-monitors" description: "Power off all monitors via DPMS"}
    {value: "power-on-monitors" description: "Power on all monitors via DPMS"}
    {value: "spawn" description: "Spawn a command"}
    {value: "do-screen-transition" description: "Do a screen transition"}
    {value: "screenshot" description: "Open the screenshot UI"}
    {value: "screenshot-screen" description: "Screenshot the focused screen"}
    {value: "screenshot-window" description: "Screenshot the focused window"}
    {value: "close-window" description: "Close the focused window"}
    {value: "fullscreen-window" description: "Toggle fullscreen on the focused window"}
    {value: "focus-window" description: "Focus a window by id"}
    {value: "focus-window-in-column" description: "Focus a window in the focused column by index"}
    {value: "focus-window-previous" description: "Focus the previously focused window"}
    {value: "focus-column-left" description: "Focus the column to the left"}
    {value: "focus-column-right" description: "Focus the column to the right"}
    {value: "focus-column-first" description: "Focus the first column"}
    {value: "focus-column-last" description: "Focus the last column"}
    {value: "focus-column-right-or-first" description: "Focus the next column to the right, looping if at end"}
    {value: "focus-column-left-or-last" description: "Focus the next column to the left, looping if at start"}
    {value: "focus-window-or-monitor-up" description: "Focus the window or the monitor above"}
    {value: "focus-window-or-monitor-down" description: "Focus the window or the monitor below"}
    {value: "focus-column-or-monitor-left" description: "Focus the column or the monitor to the left"}
    {value: "focus-column-or-monitor-right" description: "Focus the column or the monitor to the right"}
    {value: "focus-window-down" description: "Focus the window below"}
    {value: "focus-window-up" description: "Focus the window above"}
    {value: "focus-window-down-or-column-left" description: "Focus the window below or the column to the left"}
    {value: "focus-window-down-or-column-right" description: "Focus the window below or the column to the right"}
    {value: "focus-window-up-or-column-left" description: "Focus the window above or the column to the left"}
    {value: "focus-window-up-or-column-right" description: "Focus the window above or the column to the right"}
    {value: "focus-window-or-workspace-down" description: "Focus the window or the workspace above"}
    {value: "focus-window-or-workspace-up" description: "Focus the window or the workspace above"}
    {value: "focus-window-top" description: "Focus the topmost window"}
    {value: "focus-window-bottom" description: "Focus the bottommost window"}
    {value: "focus-window-down-or-top" description: "Focus the window below or the topmost window"}
    {value: "focus-window-up-or-bottom" description: "Focus the window above or the bottommost window"}
    {value: "move-column-left" description: "Move the focused column to the left"}
    {value: "move-column-right" description: "Move the focused column to the right"}
    {value: "move-column-to-first" description: "Move the focused column to the start of the workspace"}
    {value: "move-column-to-last" description: "Move the focused column to the end of the workspace"}
    {value: "move-column-left-or-to-monitor-left" description: "Move the focused column to the left or to the monitor to the left"}
    {value: "move-column-right-or-to-monitor-right" description: "Move the focused column to the right or to the monitor to the right"}
    {value: "move-window-down" description: "Move the focused window down in a column"}
    {value: "move-window-up" description: "Move the focused window up in a column"}
    {value: "move-window-down-or-to-workspace-down" description: "Move the focused window down in a column or to the workspace below"}
    {value: "move-window-up-or-to-workspace-up" description: "Move the focused window up in a column or to the workspace above"}
    {value: "consume-or-expel-window-left" description: "Consume or expel the focused window left"}
    {value: "consume-or-expel-window-right" description: "Consume or expel the focused window right"}
    {value: "consume-window-into-column" description: "Consume the window to the right into the focused column"}
    {value: "expel-window-from-column" description: "Expel the focused window from the column"}
    {value: "swap-window-right" description: "Swap focused window with one to the right"}
    {value: "swap-window-left" description: "Swap focused window with one to the left"}
    {value: "toggle-column-tabbed-display" description: "Toggle the focused column between normal and tabbed display"}
    {value: "set-column-display" description: "Set the display mode of the focused column"}
    {value: "center-column" description: "Center the focused column on the screen"}
    {value: "center-window" description: "Center the focused window on the screen"}
    {value: "focus-workspace-down" description: "Focus the workspace below"}
    {value: "focus-workspace-up" description: "Focus the workspace above"}
    {value: "focus-workspace" description: "Focus a workspace by reference (index or name)"}
    {value: "focus-workspace-previous" description: "Focus the previous workspace"}
    {value: "move-window-to-workspace-down" description: "Move the focused window to the workspace below"}
    {value: "move-window-to-workspace-up" description: "Move the focused window to the workspace above"}
    {value: "move-window-to-workspace" description: "Move the focused window to a workspace by reference (index or name)"}
    {value: "move-column-to-workspace-down" description: "Move the focused column to the workspace below"}
    {value: "move-column-to-workspace-up" description: "Move the focused column to the workspace above"}
    {value: "move-column-to-workspace" description: "Move the focused column to a workspace by reference (index or name)"}
    {value: "move-workspace-down" description: "Move the focused workspace down"}
    {value: "move-workspace-up" description: "Move the focused workspace up"}
    {value: "move-workspace-to-index" description: "Move the focused workspace to a specific index on its monitor"}
    {value: "set-workspace-name" description: "Set the name of the focused workspace"}
    {value: "unset-workspace-name" description: "Unset the name of the focused workspace"}
    {value: "focus-monitor-left" description: "Focus the monitor to the left"}
    {value: "focus-monitor-right" description: "Focus the monitor to the right"}
    {value: "focus-monitor-down" description: "Focus the monitor below"}
    {value: "focus-monitor-up" description: "Focus the monitor above"}
    {value: "focus-monitor-previous" description: "Focus the previous monitor"}
    {value: "focus-monitor-next" description: "Focus the next monitor"}
    {value: "move-window-to-monitor-left" description: "Move the focused window to the monitor to the left"}
    {value: "move-window-to-monitor-right" description: "Move the focused window to the monitor to the right"}
    {value: "move-window-to-monitor-down" description: "Move the focused window to the monitor below"}
    {value: "move-window-to-monitor-up" description: "Move the focused window to the monitor above"}
    {value: "move-window-to-monitor-previous" description: "Move the focused window to the previous monitor"}
    {value: "move-window-to-monitor-next" description: "Move the focused window to the next monitor"}
    {value: "move-column-to-monitor-left" description: "Move the focused column to the monitor to the left"}
    {value: "move-column-to-monitor-right" description: "Move the focused column to the monitor to the right"}
    {value: "move-column-to-monitor-down" description: "Move the focused column to the monitor below"}
    {value: "move-column-to-monitor-up" description: "Move the focused column to the monitor above"}
    {value: "move-column-to-monitor-previous" description: "Move the focused column to the previous monitor"}
    {value: "move-column-to-monitor-next" description: "Move the focused column to the next monitor"}
    {value: "set-window-width" description: "Change the width of the focused window"}
    {value: "set-window-height" description: "Change the height of the focused window"}
    {value: "reset-window-height" description: "Reset the height of the focused window back to automatic"}
    {value: "switch-preset-column-width" description: "Switch between preset column widths"}
    {value: "switch-preset-window-width" description: "Switch between preset window widths"}
    {value: "switch-preset-window-height" description: "Switch between preset window heights"}
    {value: "maximize-column" description: "Toggle the maximized state of the focused column"}
    {value: "set-column-width" description: "Change the width of the focused column"}
    {value: "expand-column-to-available-width" description: "Expand the focused column to space not taken up by other fully visible columns"}
    {value: "switch-layout" description: "Switch between keyboard layouts"}
    {value: "show-hotkey-overlay" description: "Show the hotkey overlay"}
    {value: "move-workspace-to-monitor-left" description: "Move the focused workspace to the monitor to the left"}
    {value: "move-workspace-to-monitor-right" description: "Move the focused workspace to the monitor to the right"}
    {value: "move-workspace-to-monitor-down" description: "Move the focused workspace to the monitor below"}
    {value: "move-workspace-to-monitor-up" description: "Move the focused workspace to the monitor above"}
    {value: "move-workspace-to-monitor-previous" description: "Move the focused workspace to the previous monitor"}
    {value: "move-workspace-to-monitor-next" description: "Move the focused workspace to the next monitor"}
    {value: "move-workspace-to-monitor" description: "Move the focused workspace to a specific monitor"}
    {value: "toggle-debug-tint" description: "Toggle a debug tint on windows"}
    {value: "debug-toggle-opaque-regions" description: "Toggle visualization of render element opaque regions"}
    {value: "debug-toggle-damage" description: "Toggle visualization of output damage"}
    {value: "toggle-window-floating" description: "Move the focused window between the floating and the tiling layout"}
    {value: "move-window-to-floating" description: "Move the focused window to the floating layout"}
    {value: "move-window-to-tiling" description: "Move the focused window to the tiling layout"}
    {value: "focus-floating" description: "Switches focus to the floating layout"}
    {value: "focus-tiling" description: "Switches focus to the tiling layout"}
    {value: "switch-focus-between-floating-and-tiling" description: "Toggles the focus between the floating and the tiling layout"}
    {value: "move-floating-window" description: "Move the floating window on screen"}
    {value: "toggle-window-rule-opacity" description: "Toggle the opacity of the focused window"}
    {value: "help" description: "Print this message or the help of the given subcommand(s)"}
  ]
}

# Communicate with the running niri instance
export extern "niri msg" [
  --json (-j) #  Format output as JSON
  --help (-h) #  Print help
  command?: string@"nu-complete niri msg"
]

# Perform an action
export extern "niri msg action" [
  command: string@"nu-complete niri msg action"
  --help (-h) # Print help information
]
# Perform an action
# export extern "niri msg --json action" [
#   command: string@"nu-complete niri msg action"
#   --help (-h) # Print help information
# ]

export extern "niri" [
  --config (-c): string = "" # Path to config file (default: `$XDG_CONFIG_HOME/niri/config.kdl`). This can also be set with the `NIRI_CONFIG` environment variable. If both are set, the command line argument takes precedence.
  --session # Import environment globally to systemd and D-Bus, run D-Bus services. Set this flag in a systemd service started by your display manager, or when running manually as your main compositor instance. Do not set when running as a nested window, or on a TTY as your non-main compositor instance, to avoid messing up the global environment.
  --help (-h) # Print help (see a summary with '-h')
  --version (-V) # Print version
  command?: string@"nu-complete niri"
  ...rest: any
]
