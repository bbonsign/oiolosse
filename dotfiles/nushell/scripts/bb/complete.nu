# Keep the selected record intact: its value and byte span come from Nushell,
# not from parsing the display text returned by fzf.
def pick-completion [completions: list<record>] {
  if ($completions | is-empty) {
    return null
  }

  # Capture stdout only: fzf needs stderr connected to the terminal for its UI.
  let selection = try {
    $completions
    | enumerate
    | each {|entry|
      let suggestion = $entry.item
      let label = [
        ($suggestion.display_override? | default $suggestion.value)
        ($suggestion.description? | default "")
      ] | str join " — " | ansi strip | str replace --all --regex '\s+' ' '
      $"($entry.index)\t($label)"
    }
    | str join (char nl)
    | ^fzf --delimiter (char tab) --with-nth 2.. --select-1
  } catch {|err|
    if $err.exit_code? in [1 130] { null } else { error make $err }
  }

  if $selection == null {
    return null
  }

  let index = $selection | split row (char tab) | first | into int
  $completions | get $index
}

# Ctrl-J runs as an execute-host-command, so the engine completes the editor
# buffer at its actual cursor and leaves text beyond the replacement span alone.
export def fzf-complete [] {
  let buffer = commandline
  let suggestion = pick-completion (commandline complete --detailed)
  if $suggestion == null {
    return
  }

  let before = $buffer | str substring --utf-8-bytes ..<$suggestion.span.start
  let after = $buffer | str substring --utf-8-bytes $suggestion.span.end..
  let padding = if (
    ($suggestion.append_whitespace? | default false)
    and not ($suggestion.value | str ends-with ' ')
    and not ($after | str starts-with ' ')
  ) { ' ' } else { '' }
  let completed = $before + $suggestion.value + $padding

  commandline edit --replace ($completed + $after)
  commandline set-cursor ($completed | str length --grapheme-clusters)
}

# Menu inputs are the line through the cursor. Return the engine's suggestion
# directly so Reedline replaces only its span and preserves the suffix.
export def fzf_menu_source [buffer: string] {
  let suggestion = pick-completion ($buffer | commandline complete --detailed)
  if $suggestion == null { [] } else { [$suggestion] }
}
