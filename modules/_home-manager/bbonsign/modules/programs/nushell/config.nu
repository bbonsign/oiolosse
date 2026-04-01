# source ~/.cache/carapace/init.nu

# ~/.config/nushell/scripts/bb module
use bb *

const ALL_MODES = [emacs vi_normal vi_insert]

let fzf_menu_source = {|buffer, position|
  fzf_menu_source $buffer $position
}

#################
## $env.config ##
#################

$env.config.show_banner = false

$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

$env.config.cursor_shape = {
  emacs: inherit # block, underscore, line (line is the default)
  vi_insert: line # block, underscore, line (block is the default)
  vi_normal: block # block, underscore, line (underscore is the default)
}

$env.config.completions = {
  algorithm: fuzzy
  external: {
    enable: false
  }
}

$env.config.menus = (
  $env.config.menus | append [
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
      source: $fzf_menu_source
    }
    {
      name: completion_menu
      only_buffer_difference: false # Search is done on the text written after activating the menu
      marker: "" # Indicator that appears with the menu is active
      type: {
        layout: columnar # Type of menu
        columns: 4 # Number of columns where the options are displayed
        col_width: 20 # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2 # Padding between columns
      }
      style: {
        text: green # Text style
        selected_text: green_reverse # Text style for selected option
        description_text: yellow # Text style for description
      }
    }
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
      source: {|buffer, position|
        scope aliases
        | where name == ($buffer | str trim)
        | each {|it| {value: $"($it.expansion) "} }
      }
    }
    # https://discord.com/channels/601130461678272522/1412981516514103379/1412981611024089151
    #     This menu adds smart completions for the last command in your pipeline.
    # It looks at your history and suggests all the variants you’ve actually used — including flags and further pipelines.
    #
    # Features:
    #     •    Matches the last segment of your current pipeline, even inside groups and sub-pipelines.
    #     •    Filters history for commands starting with your current segment.
    #     •    Deduplicates and presents results in a clean, scrollable list (page_size: 25).
    #     •    Styled for readability: green for text, yellow for descriptions.
    #
    # Use this when you want to quickly recall and reuse the exact command forms you’ve typed before, instead of guessing or re-typing flags and arguments from memory.#
    {
      name: pipe_completions_menu
      only_buffer_difference: false # Search is done on the text written after activating the menu
      marker: ""
      type: { layout: list page_size: 25 }
      style: { text: green selected_text: green_reverse description_text: yellow }
      source: {|buffer position|

        let esc_regex: closure = {|input|
          # regex special symbols
          [
            '\' '.' '^' '$' '*'
            '+' '?' '{' '}' '('
            ')' '[' ']' '|' '/'
          ]
          | reduce -f $input {|i acc| $acc | str replace -a $i $'\($i)' }
        }


        let segments = $buffer | split row -r '(\s\|\s)|\(|;|(\{\|\w\| )'
        let last_segment = $segments | last
        let last_segment_length = $last_segment | str length
        let last_segment_esc = do $esc_regex $last_segment
        let smt = $buffer | str replace -r $'($last_segment_esc)$' ' '

        history
        | get command
        | uniq
        | where $it =~ $last_segment_esc
        | str replace -a (char nl) ' '
        | str replace -r $'.*($last_segment_esc)' $last_segment
        | reverse
        | uniq
        | each {|it| { value: $it span: { start: ($position - $last_segment_length) end: ($position) } } }
      }
    }
  ]
)

# https://github.com/nushell/nushell/issues/5552#issuecomment-2077047961
$env.config.keybindings = (
  $env.config.keybindings | append [
    {
      name: fuzzy_tab
      modifier: control
      keycode: char_j
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: `commandline edit ( fzf-complete (commandline) (commandline get-cursor))`
      }
    }
    {
      name: fzf_menu
      # modifier: none
      # keycode: tab
      modifier: control
      keycode: char_o
      mode: $ALL_MODES
      event: {
        until: [
          {send: menu name: fzf_menu}
          # { edit: InsertString, value: "After fzf_menu" }
          # { send: menu, name: completion_menu }
          # { edit: InsertString, value: "After nu completion_menu" }
          # { send: MenuNext }
        ]
      }
    }
    {
      name: abbr
      modifier: control
      keycode: space
      mode: $ALL_MODES
      event: {
        send: menu
        name: abbr_menu
      }
    }
    # {
    #   name: completion_menu
    #   modifier: control
    #   keycode: char_j
    #   mode: $ALL_MODES
    #   event: {
    #     until: [
    #       { send: menu, name: completion_menu }
    #       { send: MenuNext }
    #     ]
    #   }
    # },
    {
      name: pipe_completions_menu
      modifier: alt
      keycode: char_p
      mode: $ALL_MODES
      event: {send: menu name: pipe_completions_menu}
    }

    {
      name: fuzzy_file_pwd
      modifier: control
      keycode: char_s
      mode: $ALL_MODES
      event: {send: Enter}
    }
    {
      name: fuzzy_file
      modifier: control
      keycode: char_t
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fzf-tmux -- --multi | lines | each {'\"' + $in + '\"'} | str join ' ')"
      }
    }
    {
      name: fuzzy_file_pwd
      modifier: control_alt
      keycode: char_j
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fd --max-depth 1 --color always | fzf-tmux)"
      }
    }
    {
      name: fuzzy_git_status
      modifier: control_alt
      keycode: char_s
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert ('\"' + (fg status) + '\"')"
      }
    }
    {
      name: fuzzy_git_branch
      modifier: control_alt
      keycode: char_b
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fg branches)"
      }
    }
    {
      name: fuzzy_git_branch_all
      modifier: control_alt
      keycode: char_g
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fg branches --all)"
      }
    }
    {
      name: open_prompt_in_editor
      modifier: alt
      keycode: char_e
      mode: $ALL_MODES
      event: {send: OpenEditor}
    }
    {
      name: wrap_commandline_in_nvim_quickfix
      modifier: control
      keycode: char_q
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "wrap_commandline_in_nvim_quickfix"
      }
    }
    # Extend regular bindings to all vi+emacs modes
    {
      name: clear_backwards
      modifier: control
      keycode: char_u
      mode: $ALL_MODES
      event: [
        {edit: CutFromLineStart}
        {edit: Backspace}
      ]
    }
    {
      name: clear_forwards
      modifier: control
      keycode: char_k
      mode: $ALL_MODES
      event: [
        {edit: ClearToLineEnd}
        {edit: Delete}
      ]
    }
    {
      name: complete_hint
      modifier: control
      keycode: char_f
      mode: $ALL_MODES
      event: {
        until: [
          {send: HistoryHintComplete}
          {send: MenuRight}
          {send: Right}
        ]
      }
    }
    {
      name: complete_hint_incremental
      modifier: alt
      keycode: char_f
      mode: $ALL_MODES
      event: {
        until: [
          {send: HistoryHintWordComplete}
          {edit: MoveWordRight select: false}
        ]
      }
    }
  ]
)

# export def fzy-get [
#   column: string = ""
#   query: string = ""
# ]: table -> any {
#   let in_file = $in | table | as file
#   let columns = $in | columns
#   let column = if ($column | is-empty) {
#     gum filter --height (($columns | length) + 3 ) ...$columns
#   } else {
#     $column
#   }
#   let parser = $columns | each {$"\(?P<($in)>.*\)"} | str join "\t+"
#
#   $in 
#   | to tsv 
#   | ^column --table --separator "\t" --output-separator "\t" # align columns
#   | (fzf 
#     --query $query
#     --header-lines 1
#     --preview-window 'down:50%,hidden'
#     --preview $"bat ($in_file)"
#   )
#   | parse --regex $parser
#   | default {}
#   | get $column
#   | get 0?
#   | default ""
#   | str trim
# }
