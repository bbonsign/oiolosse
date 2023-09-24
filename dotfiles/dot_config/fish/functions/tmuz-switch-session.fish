function tmuz-switch-session --description 'Switch tmux session'
  tmux list-sessions -F "#{session_name}" | fzf | read -l result; and tmux switch-client -t "$result"
end
