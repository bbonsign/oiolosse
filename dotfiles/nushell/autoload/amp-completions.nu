# Nushell completions for Amp CLI (https://ampcode.com)

# ============================================================================
# Static Completers
# ============================================================================

def "nu-complete amp subcommands" [] {
  [
    { value: login       description: "Log in to Amp" }
    { value: logout      description: "Log out by removing stored API key" }
    { value: threads     description: "Manage threads" }
    { value: t           description: "Alias for threads" }
    { value: thread      description: "Alias for threads" }
    { value: tools       description: "Tool management commands" }
    { value: tool        description: "Alias for tools" }
    { value: skill       description: "Manage skills from GitHub or local sources" }
    { value: skills      description: "Alias for skill" }
    { value: permissions description: "Manage permissions" }
    { value: permission  description: "Alias for permissions" }
    { value: mcp         description: "Manage MCP servers" }
    { value: update      description: "Update Amp CLI" }
  ]
}

def "nu-complete amp threads subcommands" [] {
  [
    { value: new      description: "Create a new thread" }
    { value: n        description: "Alias for new" }
    { value: continue description: "Continue an existing thread" }
    { value: c        description: "Alias for continue" }
    { value: fork     description: "Fork an existing thread" }
    { value: f        description: "Alias for fork" }
    { value: list     description: "List all threads" }
    { value: l        description: "Alias for list" }
    { value: ls       description: "Alias for list" }
    { value: search   description: "Search threads" }
    { value: find     description: "Alias for search" }
    { value: share    description: "Share a thread" }
    { value: s        description: "Alias for share" }
    { value: rename   description: "Rename a thread" }
    { value: r        description: "Alias for rename" }
    { value: archive  description: "Archive a thread" }
    { value: markdown description: "Render thread as markdown" }
    { value: md       description: "Alias for markdown" }
    { value: replay   description: "Replay a thread" }
    { value: p        description: "Alias for replay" }
  ]
}

def "nu-complete amp tools subcommands" [] {
  [
    { value: list description: "List all active tools (including MCP tools)" }
    { value: ls   description: "Alias for list" }
    { value: show description: "Show details about an active tool" }
    { value: make description: "Sets up a skeleton tool in your toolbox" }
    { value: use  description: "Invoke a tool with arguments or JSON input from stdin" }
  ]
}

def "nu-complete amp skill subcommands" [] {
  [
    { value: add        description: "Install skills from a source" }
    { value: publish    description: "Publish a skill to Amp marketplace" }
    { value: visibility description: "Change visibility of a published skill" }
    { value: list       description: "List all available skills" }
    { value: ls         description: "Alias for list" }
    { value: remove     description: "Remove an installed skill" }
    { value: rm         description: "Alias for remove" }
    { value: update     description: "Update installed skills to their latest versions" }
    { value: info       description: "Show information about a skill" }
  ]
}

def "nu-complete amp permissions subcommands" [] {
  [
    { value: list description: "List permissions" }
    { value: ls   description: "Alias for list" }
    { value: test description: "Test permissions" }
    { value: edit description: "Edit permissions" }
    { value: add  description: "Add permission rule" }
  ]
}

def "nu-complete amp mcp subcommands" [] {
  [
    { value: add    description: "Add an MCP server configuration" }
    { value: list   description: "List all MCP server configurations" }
    { value: remove description: "Remove an MCP server configuration" }
    { value: oauth  description: "Manage OAuth authentication for MCP servers" }
    { value: doctor description: "Check MCP server status" }
  ]
}

def "nu-complete amp mcp oauth subcommands" [] {
  [
    { value: login  description: "Register OAuth client credentials for an MCP server" }
    { value: logout description: "Remove OAuth credentials for an MCP server" }
    { value: status description: "Show OAuth status for an MCP server" }
  ]
}

def "nu-complete amp visibility" [] {
  [private public workspace group]
}

def "nu-complete amp log-level" [] {
  [error warn info debug audit]
}

def "nu-complete amp mode" [] {
  [free rush smart]
}

# ============================================================================
# Dynamic Completers
# ============================================================================

def "nu-complete amp thread-ids" [] {
  try {
    ^amp threads list
    | lines
    | skip 2  # skip header and separator line
    | where ($it | str trim | is-not-empty)
    | each {|line|
        # Format: "Title  Last Updated  Visibility  Messages  Thread ID"
        # Thread ID is at the end, Title at the start
        let parts = ($line | split row "  " | where ($it | str trim | is-not-empty))
        let thread_id = ($parts | last | str trim)
        let title = ($parts | first | str trim)
        { value: $thread_id description: $title }
      }
  } catch { [] }
}

def "nu-complete amp tool-names" [] {
  try {
    ^amp tools list
    | lines
    | skip 1
    | each {|line| $line | str trim | split column " " | get column1 | get 0}
  } catch { [] }
}

def "nu-complete amp skill-names" [] {
  try {
    ^amp skill list
    | lines
    | skip 1
    | each {|line| $line | str trim | split column " " | get column1 | get 0}
  } catch { [] }
}

def "nu-complete amp mcp-servers" [] {
  try {
    ^amp mcp list
    | lines
    | skip 1
    | each {|line| $line | str trim | split column " " | get column1 | get 0}
  } catch { [] }
}

# ============================================================================
# Extern Declarations
# ============================================================================

# Top-level amp command
export extern amp [
  command?: string@"nu-complete amp subcommands"
  --visibility: string@"nu-complete amp visibility"  # Set thread visibility
  --version(-V)                                       # Print the version number and exit
  --notifications                                     # Enable sound notifications
  --no-notifications                                  # Disable sound notifications
  --settings-file: path                               # Custom settings file path
  --log-level: string@"nu-complete amp log-level"    # Set log level
  --log-file: path                                    # Set log file location
  --dangerously-allow-all                             # Disable all command confirmation prompts
  --jetbrains                                         # Enable JetBrains integration
  --no-jetbrains                                      # Disable JetBrains integration
  --ide                                               # Enable IDE connection
  --no-ide                                            # Disable IDE connection
  --mcp-config: string                                # JSON configuration for MCP servers
  --use-sonnet                                        # Use Claude Sonnet instead of Opus
  --no-use-sonnet                                     # Use default model (Opus)
  --mode(-m): string@"nu-complete amp mode"          # Set the agent mode
  --execute(-x): string                               # Use execute mode
  --stream-json                                       # Output in stream JSON format
  --stream-json-input                                 # Read JSON Lines from stdin
  ...rest
]

# Threads command
export extern "amp threads" [
  command?: string@"nu-complete amp threads subcommands"
  ...rest
]

export extern "amp t" [
  command?: string@"nu-complete amp threads subcommands"
  ...rest
]

export extern "amp thread" [
  command?: string@"nu-complete amp threads subcommands"
  ...rest
]

export extern "amp threads new" [
  --visibility: string@"nu-complete amp visibility"
  ...rest
]

export extern "amp threads continue" [
  thread?: string@"nu-complete amp thread-ids"
  --execute(-x): string
  ...rest
]

export extern "amp threads c" [
  thread?: string@"nu-complete amp thread-ids"
  --execute(-x): string
  ...rest
]

export extern "amp threads fork" [
  thread?: string@"nu-complete amp thread-ids"
  ...rest
]

export extern "amp threads share" [
  thread?: string@"nu-complete amp thread-ids"
  --visibility: string@"nu-complete amp visibility"
  ...rest
]

export extern "amp threads rename" [
  thread?: string@"nu-complete amp thread-ids"
  ...rest
]

export extern "amp threads archive" [
  thread?: string@"nu-complete amp thread-ids"
  ...rest
]

export extern "amp threads markdown" [
  thread?: string@"nu-complete amp thread-ids"
  ...rest
]

export extern "amp threads replay" [
  thread?: string@"nu-complete amp thread-ids"
  ...rest
]

# Tools command
export extern "amp tools" [
  command?: string@"nu-complete amp tools subcommands"
  ...rest
]

export extern "amp tool" [
  command?: string@"nu-complete amp tools subcommands"
  ...rest
]

export extern "amp tools show" [
  tool?: string@"nu-complete amp tool-names"
]

export extern "amp tools use" [
  tool?: string@"nu-complete amp tool-names"
  ...rest
]

# Skill command
export extern "amp skill" [
  command?: string@"nu-complete amp skill subcommands"
  ...rest
]

export extern "amp skills" [
  command?: string@"nu-complete amp skill subcommands"
  ...rest
]

export extern "amp skill remove" [
  skill?: string@"nu-complete amp skill-names"
]

export extern "amp skill rm" [
  skill?: string@"nu-complete amp skill-names"
]

export extern "amp skill info" [
  skill?: string@"nu-complete amp skill-names"
]

export extern "amp skill update" [
  skill?: string@"nu-complete amp skill-names"
  ...rest
]

# Permissions command
export extern "amp permissions" [
  command?: string@"nu-complete amp permissions subcommands"
  ...rest
]

export extern "amp permission" [
  command?: string@"nu-complete amp permissions subcommands"
  ...rest
]

# MCP command
export extern "amp mcp" [
  command?: string@"nu-complete amp mcp subcommands"
  ...rest
]

export extern "amp mcp oauth" [
  command?: string@"nu-complete amp mcp oauth subcommands"
  ...rest
]

export extern "amp mcp remove" [
  server?: string@"nu-complete amp mcp-servers"
]

export extern "amp mcp doctor" [
  server?: string@"nu-complete amp mcp-servers"
  ...rest
]
