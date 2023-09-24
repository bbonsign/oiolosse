# Defined in - @ line 1
function lt4 --wraps='exa --all --long --group-directories-first --git-ignore --icons --tree -L4' --description 'alias lt4 exa --all --long --group-directories-first --icons --tree -L4'
  exa --all --long --group-directories-first --git-ignore -I '.git' --icons --tree -L4 $argv;
end
