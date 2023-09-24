# Defined in - @ line 1
function tree --wraps='tree --dirsfirst' --description 'alias tree=tree --dirsfirst'
 command tree --dirsfirst $argv;
end
