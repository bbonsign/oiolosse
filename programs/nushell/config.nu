source ~/.cache/carapace/init.nu

$env.config = {
    # aka, show the nushell start message
    # show_banner: false,

    # completions: {
    #     external: {
    #         enable: true
    #         completer: $external_completer
    #     }
    # },

    cursor_shape: {
        emacs: inherit # block, underscore, line (line is the default)
            vi_insert: inherit # block, underscore, line (block is the default)
            vi_normal: inherit # block, underscore, line  (underscore is the default)
    },

    # https://github.com/nushell/nushell/issues/5552#issuecomment-2077047961
    keybindings: [ 
      {
        name: abbr
        modifier: control
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
          { send: menu name: abbr_menu }
          { edit: insertchar, value: ' '}
        ]
      }
    ],

    menus: [
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
          | each { |it| {value: $it.expansion }}
        }
      }
    ]
}
