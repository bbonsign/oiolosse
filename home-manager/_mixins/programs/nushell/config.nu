source ~/.config/nushell/scripts/themes/nu-themes/tokyo-night.nu
source ~/.cache/carapace/init.nu

# config scripts/: module
use bb *

let fish_completer = {|spans|
  fish --command $'complete "--do-complete=($spans | str join " ")"'
  | from tsv --flexible --noheaders --no-infer
  | rename value description
}

let carapace_completer = {|spans: list<string>|
  carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
  let expanded_alias = scope aliases
  | where name == $spans.0?
  | get --ignore-errors 0.expansion

  let spans = if $expanded_alias != null {
    $spans
    | skip 1
    | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }

  match $spans.0 {
    # carapace completions are incorrect for nu
    # nu => $fish_completer
    # fish completes commits and branch names in a nicer way
    # git => $fish_completer
    # carapace doesn't have completions for asdf
    asdf => $fish_completer
    _ => $carapace_completer
  } | do $in $spans
}

# def fuzzy-tab [...commandline: string] {
def fuzzy-tab [] list<string> -> string {
  # let commandline = commandline | split row -r '\s+'
  # let cursor_position = commandline get-cursor
  let res = do $external_completer $in
  match $res {
    null => { return "" }
    [] => {return ""}
    _ => $res
  }

  let max_len = $res
  | each { $in.value | str length }
  | math max

  let return_val = $res
  | each {|x|
    $"(ansi --escape ($x.style? | default {}))($x.value | fill --alignment l --width $max_len)(ansi reset)\t(ansi yellow_bold)($x.description? | default "" | str trim)(ansi reset)"
  }
  | to text
  | fzf --ansi
  | parse --regex '(?<completion_target>.*)\t\s*(?P<description>.*)'
  | get completion_target?
  | default [""]
  | each {str trim }
  | str join " "
  # commandline set-cursor ($cursor_position + ($return_val | str length) + 1)
  $return_val
}

$env.config = {
  # aka, show the nushell start message
  show_banner: false,

  completions: {
    algorithm: fuzzy
    external: {
      enable: true
      completer: $external_completer
    }
  },

  history: {max_size: 10000},

  cursor_shape: {
    emacs: inherit      # block, underscore, line (line is the default)
    vi_insert: line     # block, underscore, line (block is the default)
    vi_normal: block    # block, underscore, line (underscore is the default)
  },

  # https://github.com/nushell/nushell/issues/5552#issuecomment-2077047961
  keybindings: [
    {
      name: fuzzy_tab
      modifier: control
      keycode: char_t
      mode: emacs
      event: {
        send: executehostcommand
        cmd: `commandline edit --insert (commandline | split row -r '\s+' | fuzzy-tab)`
      }
    },
    {
      name: fzf_menu
      modifier: control
      keycode: char_y
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: menu
        name: fzf_menu
      }
    },
    {
      name: abbr
      modifier: control
      keycode: space
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: menu
        name: abbr_menu
      }
    },
    {
      name: fuzzy_file
      modifier: control
      keycode: char_j
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fzf-tmux)"
      }
    },
    {
      name: fuzzy_file
      modifier: control_alt
      keycode: char_j
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fzf-tmux)"
      }
    },
    {
      name: fuzzy_git_status
      modifier: control_alt
      keycode: char_s
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fg status)"
      }
    },
    {
      name: fuzzy_git_branch
      modifier: control_alt
      keycode: char_b
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fg branches)"
      }
    },
    {
      name: fuzzy_git_branch_all
      modifier: control_alt
      keycode: char_g
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fg branches --all)"
      }
    },
    # Extend regular bindings to all vi+emacs modes
    {
      name: clear_backwards
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: CutFromStart },
    },
    {
      name: clear_forwards
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: { edit: ClearToLineEnd }
    },
    {
      name: complete_hint
      modifier: control
      keycode: char_f
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {send: HistoryHintComplete},
          {send: MenuRight},
          {send: Right},
        ]
      }
    },
    {
      name: complete_hint_incremental
      modifier: alt
      keycode: char_f
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {send: HistoryHintWordComplete},
          {edit: MoveWordRight, select: false},
        ]
      }
    },
  ],

  menus: [
    {
      name: fzf_menu
      only_buffer_difference: false
      marker: ""
      type: {
        layout: columnar
        columns: 1
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        let tokens = $buffer | split row -r '\s+'
        let result = $tokens
        | fuzzy-tab
        | do {
          let selected_value = $in
          {
            value: ($tokens | range 0..-2 | append $selected_value)
            span: {
              start: position
            }
          }
        }
        $result | inspect
      }
    },
    {
      name: abbr_menu
      only_buffer_difference: false
      marker: ""
      type: {
        layout: columnar
        columns: 1
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        scope aliases
        | where name == ($buffer | str trim)
        | each { |it| {value: $"($it.expansion) " }}
      }
    }
  ]
}
