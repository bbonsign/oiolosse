{
  "..." = "cd ../..";
  "...." = "cd ../../..";
  bx = "cd ~/Dropbox";
  conf = "cd ~/.config";
  cp = "cp -v";
  dl = "cd ~/Downloads";
  # dul = "du -h -d1 | sort -hr";
  cdr = "cd (git rev-parse --show-toplevel)";
  gcd = "cd (git rev-parse --show-toplevel)";
  icat = "kitty +kitten icat";
  l = "eza --all --long --group-directories-first --icons";
  lg = "eza --all l --group-directories-first --git";
  ll = "eza -l --group-directories-first";
  lt2 = "eza --all --long --group-directories-first --git-ignore --icons --tree -L2";
  lt3 = "eza --all --long --group-directories-first --git-ignore --icons --tree -L3";
  lt4 = "eza --all --long --group-directories-first --git-ignore --icons --tree -L4";
  lt = "eza --all --long --group-directories-first --git-ignore --icons --tree";
  mv = "mv -v";
  opnew = "open (eza -rs newest | head -1)";
  rmi = "rm -i";
  tree = "tree --dirsfirst";
}
