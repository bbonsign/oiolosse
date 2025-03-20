# Defined via `source`
function ll --wraps='exa -l --group-directories-first' --description 'alias ll=exa -l --group-directories-first'
  exa -l --group-directories-first $argv; 
end
