function gcd --description 'clone and autmatically cd into the repo'
git clone $argv[-1]  && cd (basename $argv[-1] .git)
end
