# Initially generated from `tv init nu`

def tv_smart_autocomplete [] {
  let line = (commandline)
  let cursor = (commandline get-cursor)
  let lhs = ($line | str substring 0..$cursor)
  let rhs = ($line | str substring $cursor..)
  let output = (tv --autocomplete-prompt $lhs | str trim)

  if ($output | str length) > 0 {
    let needs_space = not ($lhs | str ends-with " ")
    let lhs_with_space = if $needs_space { $"($lhs) " } else { $lhs }
    let new_line = $lhs_with_space + $output + $rhs
    let new_cursor = ($lhs_with_space + $output | str length)
    commandline edit --replace $new_line
    commandline set-cursor $new_cursor
  }
}

def tv_shell_history [] {
  let current_prompt = (commandline)
  let cursor = (commandline get-cursor)
  let current_prompt = ($current_prompt | str substring 0..$cursor)

  let output = (tv nu-history --no-status-bar --inline --input $current_prompt | str trim)

  if ($output | is-not-empty) {
    commandline edit --replace $output
    commandline set-cursor --end
  }
}

# Completions

# The first positional to `tv` is either a CHANNEL or a subcommand
# (list-channels, init, completions, update-channels, help). Merge both
# into a single completion list so users can see all valid choices.
def "nu-complete tv channel-or-subcommand" [] {
  let subcommands = [
    {value: list-channels description: "Lists the available channels"}
    {value: init description: 'Initializes shell completion ("tv init zsh")'}
    {value: completions description: "Generates standard shell tab-completion scripts"}
    {value: update-channels description: "Download the latest channel prototypes from github"}
    {value: help description: "Print help for a subcommand"}
  ]

  let channels = try {
    ^tv list-channels
    | lines
    | each {|line| $line | str trim }
    | where ($it | is-not-empty)
    | each {|name| {value: $name description: "channel"} }
  } catch { [] }

  $subcommands | append $channels
}

def "nu-complete tv border" [] {
  [none plain rounded thick]
}

def "nu-complete tv init-shell" [] {
  [bash zsh fish nu powershell]
}

def "nu-complete tv input-position" [] {
  [top bottom]
}

def "nu-complete tv layout" [] {
  [landscape portrait]
}

export extern tv [
  channel?: string@"nu-complete tv channel-or-subcommand" # CHANNEL or subcommand
  path?: path # Working directory to start in
  --help (-h) # Print help
  --version (-V) # Print version
  # Source
  --source-command (-s): string # Source command for the current channel
  --ansi # Parse ANSI style codes from source output
  --no-sort # Disable automatic sorting by match quality
  --source-display: string # Display template for source entries
  --source-output: string # Output template for source entries
  --source-entry-delimiter: string # Delimiter byte for splitting source entries
  # Preview
  --preview-command (-p): string # Preview command for the current channel
  --preview-header: string # Preview header template
  --preview-footer: string # Preview footer template
  --cache-preview # Cache preview command output per entry
  --preview-offset: string # Preview line-number offset template
  --no-preview # Disable the preview panel entirely
  --hide-preview # Hide the preview panel on startup
  --show-preview # Show the preview panel on startup
  --preview-border: string@"nu-complete tv border" # Preview panel border type
  --preview-padding: string # Preview panel padding (top=..;left=..;..)
  --preview-word-wrap # Enable preview panel word wrap
  --hide-preview-scrollbar # Hide preview panel scrollbar
  --preview-size: int # Preview panel screen percentage (1-99)
  # Input
  --input (-i): string # Prefill the prompt with this text
  --input-header: string # Input field header template
  --input-prompt: string # Input prompt string
  --input-position: string@"nu-complete tv input-position" # Input bar position
  --input-border: string@"nu-complete tv border" # Input panel border type
  --input-padding: string # Input panel padding
  # UI
  --no-status-bar # Disable the status bar entirely
  --hide-status-bar # Hide the status bar on startup
  --show-status-bar # Show the status bar on startup
  --results-border: string@"nu-complete tv border" # Results panel border type
  --results-padding: string # Results panel padding
  --layout: string@"nu-complete tv layout" # UI layout orientation
  --no-remote # Disable the remote control
  --hide-remote # Hide the remote control on startup
  --show-remote # Show the remote control on startup
  --no-help-panel # Disable the help panel entirely
  --hide-help-panel # Hide the help panel on startup
  --show-help-panel # Show the help panel on startup
  --ui-scale: int # Display size as percentage of available area
  --height: int # Height in lines (non-fullscreen mode)
  --width: int # Width in columns (with --inline/--height)
  --inline # Use bottom of terminal as inline interface
  # Behavior
  --tick-rate (-t): int # Application tick rate
  --watch: float # Reload source command every N seconds
  --autocomplete-prompt: string # Guess the channel from this input prompt
  --exact # Substring matching instead of fuzzy matching
  --select-1 # Auto-select the only entry if one exists
  --take-1 # Take the first entry after loading completes
  --take-1-fast # Take the first entry as soon as it appears
  # Keybindings
  --keybindings (-k): string # Override default keybindings
  --expect: string # Extra keys that confirm the selection
  # Configuration
  --config-file: path # Custom configuration file
  --cable-dir: path # Custom cable directory
  # History
  --global-history # Use global history instead of channel-specific
]

export extern "tv init" [
  shell?: string@"nu-complete tv init-shell" # Shell to initialize for
  --help (-h)
]

export extern "tv completions" [
  shell?: string@"nu-complete tv init-shell" # Shell to generate completions for
  --help (-h)
]

export extern "tv list-channels" [
  --help (-h)
]

export extern "tv update-channels" [
  --help (-h)
]

# Bind custom keybindings
$env.config = (
  $env.config
  | upsert keybindings (
    $env.config.keybindings
    | append [
      {
        name: tv_completion
        modifier: Control
        keycode: char_t
        mode: [vi_normal vi_insert emacs]
        event: {
          send: executehostcommand
          cmd: "tv_smart_autocomplete"
        }
      }
      # {
      #     name: tv_history,
      #     modifier: Control,
      #     keycode: char_r,
      #     mode: [vi_normal, vi_insert, emacs],
      #     event: {
      #         send: executehostcommand,
      #         cmd: "tv_shell_history"
      #     }
      # }
    ]
  )
)
