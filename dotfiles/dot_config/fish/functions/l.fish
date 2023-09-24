# Defined in - @ line 1
function l --wraps=exa --wraps='exa --all --long --group-directories-first --icons' --description 'alias l exa --all --long --group-directories-first --icons'
  exa --all --long --group-directories-first --icons $argv;
end
