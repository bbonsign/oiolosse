{
  ":b" = "cd -";
  ":bin" = "cd ~/.local/bin";
  ":bm" = "cd (cat  ~/.bookmarks | fzf )";
  ":bma" = "pwd >> ~/.bookmarks";
  ":cm" = "cmatrix -absCcyan";
  ":cwd" = "pwd | pbcopy";
  ":dev" = "export AWS_PROFILE=dev_qlair";
  ":dev_v2" = "export AWS_PROFILE=dev_v2_qlair";
  ":euprod" = "export AWS_PROFILE=prod_qlair_eu";
  ":euprod_v2" = "export AWS_PROFILE=prod_v2_qlair_eu";
  ":g" = "lazygit";
  ":gb" = "lazygit branch";
  ":gl" = "lazygit log";
  ":gs" = "lazygit status";
  ":gt" = "lazygit stash";
  ":k" = "kitty";
  ":ke" = "kitty +edit-config";
  ":ld" = "l --only-dirs";
  ":ln" = "l -s newest";
  ":loc" = "export AWS_PROFILE=local";
  ":nf" = "neofetch";
  ":po" = "poetry";
  ":por" = "poetry run";
  ":pos" = "poetry shell";
  ":prod" = "export AWS_PROFILE=prod_qlair";
  ":prod_v2" = "export AWS_PROFILE=prod_v2_qlair";
  ":pwd" = "pwd | wl-copy";
  ":sand" = "export AWS_PROFILE=sandbox";
  ":t" = "tmux attach -t";
  ":v" = "pipenv";
  ":vr" = "pipenv run";
  ":vs" = "pipenv shell";
  ":w" = "wezterm";
  ":wr" = "wezterm cli set-tab-title";
  b = "bat";
  c = "cargo";
  cl = "clear";
  cleancontainers = "docker rm -v (docker ps -a -q -f status=exited)";
  cleanimages = "docker rmi (docker images -q -f dangling=true)";
  covlet =
    "pandoc --pdf-engine=xelatex --template=moderncv.tex source/letter.md -o output/coverletter-(git rev-parse --abbrev-ref HEAD).pdf";
  d = "docker";
  dc = "docker compose";
  dce = "docker compose exec";
  dcr = "docker compose run";
  dk = "docker kill";
  dps = "docker ps";
  dpsa = "docker ps -a";
  dud = "du -sh * | sort -rh";
  e = "nvim";
  fsh = "flatpak-spawn --host";
  g = "git";
  ga = "git add";
  gaa = "git add -A";
  gau = "git add -u";
  gb = "git branch";
  gba = "git branch -a";
  gbm = "git branch --merged";
  gbsu =
    "git branch --set-upstream-to origin/(git rev-parse --abbrev-ref HEAD)";
  gc = "git commit";
  gca = "git commit --amend";
  gcb = "git clone-bare";
  gch = "git checkout";
  gcm = "git commit -m";
  gcp = "git cherry-pick";
  gd = "git diff";
  gdel = "git branch -d";
  gds = "git diff --staged";
  gf = "git fetch";
  gl =
    "git log --oneline -n 40 --date=short --boundary --pretty=format:'%Cgreen%ad %C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cblue[%aN]%Creset %Cblue'";
  gll = "git log --graph --oneline --abbrev-commit --decorate --all";
  glog = "git log --oneline";
  gm = "git merge";
  gma = "git merge --abort";
  gmm = "git merge main";
  gnew = "git checkout -b";
  gp = "git pull";
  gpp = "git push";
  gpsu = "git push --set-upstream origin";
  gr = "git remote -v";
  grpo = "git remote prune origin";
  gst = "git status";
  gt = "git stash";
  gtp = "git stash pop";
  gtd = "git stash show -p";
  gtl = "git stash list";
  gtrack = "git checkout --track";
  guntrack = "git rm -r --cached";
  gwt = "git worktree";
  gwta = "git worktree add";
  gwtl = "git worktree list";
  gwtr = "git worktree remove";
  ipy = "ipython";
  j = "just";
  jz = "just --choose";
  lg = "l --git";
  lgg = "l --grid";
  m = "mix";
  moon = "curl wttr.in/moon";
  myip = "curl ifconfig.co";
  n = "nnn";
  nv = "nvim";
  pc = "pre-commit";
  pd = "podman";
  pdc = "podman compose";
  pdce = "podman compose exec";
  pdcr = "podman compose run";
  pdk = "podman kill";
  pdps = "podman ps";
  pdpsa = "podman ps -a";
  pip = "python -m pip";
  pipi = "python -m pip install";
  pyhton = "python";
  pyhttp = "python -m http.server";
  rmimages = "docker rmi (docker images -q -f dangling=true)";
  t = "tmux";
  tp = "trash put";
  venv = "python -m venv";
  weather = "curl wttr.in";
  wlc = "wl-copy";
}
