function tmuz-list-keys --description 'tmux list keys with fzf'
  tmux list-keys | fzf --layout reverse
end
