source ~/.config/nnn/nnn_env_vars
source ~/.config/fish/abbr.fish

source ~/.config/fish/colors/fish_tokyonight_night.fish
# bgcolor of the current tab completion selection
set fish_color_search_match --background=4b719c

# starship init fish | source
# set -g async_prompt_functions _pure_prompt_git


if [ $HOSTNAME = toolbox ]
    alias wezterm='flatpak-spawn --host -- $HOME/.local/bin/wezterm'
    set -xg BROWSER 'flatpak-spawn --host -- flatpak run org.mozilla.firefox'
end

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    # fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    # fish_vi_key_bindings --no-erase insert

    # fzf_key_bindings &>/dev/null
    fzf_configure_bindings --variables=\e\cv --git_log=\e\cg --directory=\ct &>/dev/null
end

fish_user_key_bindings


# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
# set fish_cursor_default block
# set fish_cursor_insert line
# set fish_cursor_replace_one underscore
# set fish_cursor_visual block
# set fish_cursor_visual block

set -g fish_escape_delay_ms 10

set -xg PAGER 'bat --plain'
set -xg EDITOR nvim
set -xg VISUAL nvim
# CTRL-x opens EDITOR for editing long commands (C-x C-x in tmux)
# Note: Alt-e and Alt-v also open EDITOR for editing commands
# bind \cx edit_command_buffer

# open man pages in neovim
set -xg MANPAGER 'nvim +Man!'


set -xg FZF_DEFAULT_COMMAND "fd --color always --no-ignore --follow --ignore-file '$HOME/.config/fd/ignore'"
set -xg FZF_DEFAULT_OPTS "--ansi
                          --cycle
                          --border
                          --layout=reverse
                          --height=70%
                          --pointer='⦿'
                          --prompt=' '
                          --preview-window=right:65%
                          --bind=ctrl-u:preview-up,ctrl-d:preview-down,ctrl-space:toggle-preview
                          --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
                          --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff
                          --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
                          --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
                          "
set -xg FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window up:10:hidden:wrap"
set -xg FZF_ALT_C_COMMAND "$FZF_DEFAULT_COMMAND --type d"
set fzf_preview_dir_cmd 'exa --all --color=always --tree --level 2'
set fzf_directory_opts --bind "ctrl-e:execute($EDITOR {} &> /dev/tty)"

if command -v pyenv 1>/dev/null 2>&1
    pyenv init - | source
end

set os (uname)
source ~/.asdf/asdf.fish
# if test "$os" = "Linux"
#   # source ~/.asdf/asdf.fish
#   if test -e /opt/asdf-vm/asdf.fish
#     source /opt/asdf-vm/asdf.fish
#   end
# else
#   # Mac/homebrew
#   source /usr/local/opt/asdf/libexec/asdf.fish
# end

# pipenv completions: https://pipenv.pypa.io/en/latest/advanced/#shell-completion
# eval (env _PIPENV_COMPLETE=fish_source pipenv)

# tabtab source for packages
# uninstall by removing these lines
# [ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true


set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

set -gx PATH "$HOME/.cargo/bin" $PATH
set -gx PATH "$HOME/go/bin" $PATH

# pnpm
set -gx PNPM_HOME "/home/bbonsign/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
