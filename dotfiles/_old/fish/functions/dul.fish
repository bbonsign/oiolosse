function dul --wraps='du -h -d1 | sort -hr' --description 'alias dul=du -h -d1 | sort -hr'
  du -h -d1 | sort -hr $argv; 
end
