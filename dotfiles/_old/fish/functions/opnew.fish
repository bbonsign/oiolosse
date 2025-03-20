# Defined via `source`
function opnew --wraps='open (exa -rs newest | head -1)' --description 'alias opnew=open (exa -rs newest | head -1)'
  open (exa -rs newest | head -1) $argv; 
end
