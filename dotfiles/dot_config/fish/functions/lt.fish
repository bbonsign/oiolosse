# Defined in - @ line 1
function lt --wraps='exa --all --long --group-directories-first --git-ignore --icons --tree' --description 'alias lt exa --all --long --group-directories-first --icons --tree'
  exa --all --long --group-directories-first --git-ignore -I '.git' --icons --tree --ignore-glob=.git $argv;
end
