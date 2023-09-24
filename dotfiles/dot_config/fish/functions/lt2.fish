# Defined in - @ line 1
function lt2 --wraps='exa --all --long --group-directories-first --git-ignore --icons --tree -L2' --description 'alias lt2 exa --all --long --group-directories-first --icons --tree -L2'
  exa --all --long --group-directories-first --git-ignore -I '.git' --icons --tree -L2 $argv;
end
