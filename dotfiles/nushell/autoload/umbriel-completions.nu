def "nu-complete umbriel commands" [] {
  [
    {value: msg description: "Send an action to the running compositor"}
    {value: output-create description: "Create a virtual output"}
    {value: output-destroy description: "Destroy a virtual output"}
    {value: outputs description: "List outputs and modes"}
    {value: subscribe description: "Stream compositor events as JSON lines"}
    {value: effects description: "Inspect effect state"}
    {value: windows description: "List mapped windows"}
    {value: workspaces description: "List workspaces"}
    {value: submap description: "Inspect the active submap"}
    {value: layers description: "List layer-shell surfaces"}
    {value: color description: "Pick a color from the screen"}
    {value: tearing description: "Inspect tearing state"}
    {value: keyboard-layouts description: "List keyboard layouts"}
    {value: config description: "Validate configuration or print its schema"}
    {value: help description: "Show help"}
  ]
}

def "nu-complete umbriel actions" [place: record, token: record] {
  let rows = try {
    ^umbriel-msg list
    | lines
    | where ($it | is-not-empty)
    | each {|line|
        let fields = $line | split row "\t"
        {action: $fields.0 usage: $fields.1 description: $fields.2}
      }
  } catch { [] }

  let completions = if ($place.command | length) == 3 {
    let action = $place.command.1
    let usage = $rows | where action == $action | get -o 0.usage
    if ($usage | is-empty) {
      []
    } else {
      try {
        ^umbriel-msg candidates $usage
        | lines
        | where ($it | is-not-empty)
        | each {|line|
            let fields = $line | split row "\t"
            {
              value: $fields.0
              description: ($fields | get -o 1 | default $usage)
            }
          }
      } catch { [] }
    }
  } else if ($place.command | length) <= 2 {
    $rows
    | each {|row|
        {
          value: $row.action
          description: $"($row.description) — ($row.usage)"
        }
      }
    | append [
        {value: "--help", description: "Show action help"}
        {value: "--json", description: "Print the reply as JSON"}
      ]
  } else {
    []
  }

  $completions | where value starts-with $token.text
}

export extern umbriel [
  command?: string@"nu-complete umbriel commands"
  --config (-c): path
  --help (-h)
  --version (-V)
  ...args: string
]

@complete "nu-complete umbriel actions"
export extern "umbriel msg" [
  action?: string
  ...args: string
]
