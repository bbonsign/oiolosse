function mkcd --description 'Make directories and cd into the last directory in the list'
  mkdir $argv && cd $argv[-1];
end
# Ex: 'mkdir - p new1/new2/new3 old1/new4/new5' should create all needed directories and cd into new5
