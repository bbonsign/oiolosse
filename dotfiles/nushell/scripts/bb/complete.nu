export def fish_completer [ spans: list<string> ] {
  # print fish-comp
  fish --command $'complete "--do-complete=($spans | str join " ")"'
  | from tsv --flexible --noheaders --no-infer
  | rename value description
}

# Replicate completion action of nu for completing nu aliases and commands
# Doesn't handle arguments or options
export def nu_completer [spans: list<string>, cursor_pos: int = 0] {
  # print nu-comp
  # print $spans
  let cmd = $spans.0? | str trim
  let aliases_and_commands = (
    scope aliases
    | append (scope commands)
    | rename --column {name: value}
    | select value description
  )
  if ($cmd == "") {
    $aliases_and_commands
  } else {
    $aliases_and_commands | where value like $cmd
  }
}

export def carapace_completer [spans: list<string>, cursor_pos: int = 0] {
  # print carapace-comp
  carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
export def multi_completer [spans: list<string>, cursor_pos: int = 0] {
  let cmd = $spans.0? | str trim
  if ($cmd == "") {
    return ( nu_completer $spans )
  }

  let expanded_alias = scope aliases
  | where name == $cmd
  | get --ignore-errors 0.expansion

  let cmd = if $expanded_alias != null {
    $expanded_alias | str trim
  } else {
    $cmd | split row ' ' | take 1
  }

  let spans = $spans | skip 1 | prepend ($cmd | split row ' ')
  let carapace_completions = carapace_completer $spans

  if ($carapace_completions | is-empty) {
    let nu_completions = nu_completer $spans
    if ($nu_completions | is-empty) {
      return ( fish_completer $spans )
    }
    return $nu_completions
  }
  return $carapace_completions
}

export def fzf-complete [buffer: string, position: int = 0]  {
  let tokens = $buffer | split row -r '\s+'
  # use the last word on the commandline to only complete the remain selected part
  let last_word = $tokens | last
  let last_word_len = $last_word | str length
  let res = multi_completer $tokens $position

  match $res {
    null => { return "" }
    [] => {return ""}
    _ => $res
  }

  # To align value/description columns in fzf
  let max_len = $res
  | each { $in.value | str length }
  | math max

  let return_val = $res
  | each {|x|
    $"(ansi --escape ($x.style? | default {}))($x.value | fill --alignment l --width $max_len)(ansi reset)\t(ansi yellow_bold)($x.description? | default "" | str trim)(ansi reset)"
  }
  | to text
  | (fzf --ansi --select-1)
  | from tsv --flexible --noheaders --no-infer
  | rename completion_target description
  | get completion_target?
  | default [""]
  | each {str trim }
  | str join " "

  let completed_end = $return_val | str substring $last_word_len.. | str trim
  # Reconstruct commandline with the chosen completion
  $tokens | range 0..-2 | append $"($last_word)($completed_end)" | str join " "
}

export def fzf_menu_source [buffer: string, position: int] {
  let result = (fzf-complete $buffer $position)
  | do { { value: $in } }
  # expects a table
  [$result]
}
