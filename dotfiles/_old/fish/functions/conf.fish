# Defined in - @ line 1
function conf --wraps='cd ~/.config' --description 'alias conf=cd ~/.config'
  cd ~/.config $argv;
end
