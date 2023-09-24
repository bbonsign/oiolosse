# Defined via `source`
function lg --wraps='exa -al --group-directories-first --git' --description 'alias lg=exa -al --group-directories-first --git'
  exa -al --group-directories-first --git $argv; 
end
