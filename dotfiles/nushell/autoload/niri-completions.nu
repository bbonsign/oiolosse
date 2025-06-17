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
  niri msg action help
  | lines
  | str trim
  | split list "Actions:"
  | get 1
  | split list ""
  | get 0
  | enumerate
  | group-by { ($in.index mod 2) == 0 }
  | do {|x|
    $x.true.item
    | zip $x.false.item
  } $in
  | each { {value: $in.0 description: $in.1} }
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
