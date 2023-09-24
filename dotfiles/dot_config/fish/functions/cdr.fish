# Defined in - @ line 1
function cdr --wraps='cd (git rev-parse --git-dir)/..' --description 'alias cdr=cd (git rev-parse --git-dir)/..'
  cd (git rev-parse --git-dir)/.. $argv;
end
