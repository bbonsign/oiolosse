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
      name: fuzzy_file
      modifier: control
      keycode: char_t
      mode: $ALL_MODES
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fzf-tmux)"
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
        cmd: "commandline edit --insert (fg status)"
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
