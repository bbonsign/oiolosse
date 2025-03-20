# Defined in - @ line 1
function lt3 --wraps='exa --all --long --group-directories-first --git-ignore --icons --tree -L3' --description 'alias lt3 exa --all --long --group-directories-first --icons --tree -L3'
  exa --all --long --group-directories-first --git-ignore -I '.git' --icons --tree -L3 $argv;
end
