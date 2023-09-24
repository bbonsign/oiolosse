abbr -a -- :b 'cd -'
abbr -a -- :bin 'cd ~/.local/bin'
abbr -a -- :bm 'cd (cat  ~/.bookmarks | fzf )'
abbr -a -- :bma 'pwd >> ~/.bookmarks'
abbr -a -- :cm 'cmatrix -absCcyan'
abbr -a -- :cwd 'pwd | pbcopy'
abbr -a -- :dev 'export AWS_PROFILE=dev_qlair'
abbr -a -- :dev_v2 'export AWS_PROFILE=dev_v2_qlair'
abbr -a -- :euprod 'export AWS_PROFILE=prod_qlair_eu'
abbr -a -- :g lazygit
abbr -a -- :gb lazygit branch
abbr -a -- :gl lazygit log
abbr -a -- :gs lazygit status
abbr -a -- :gt lazygit stash
abbr -a -- :k kitty
abbr -a -- :ke 'kitty +edit-config'
abbr -a -- :ld 'l --only-dirs'
abbr -a -- :ln 'l -s newest'
abbr -a -- :loc 'export AWS_PROFILE=local'
abbr -a -- :nf neofetch
abbr -a -- :o poetry
abbr -a -- :or 'poetry run'
abbr -a -- :os 'poetry shell'
abbr -a -- :path 'export PYTHONPATH=/home/bbonsign/qlair/infra.git/develop/Lambda/DatabaseLayers/python/lib/python3.8/site-packages'
abbr -a -- :po poetry
abbr -a -- :prod 'export AWS_PROFILE=prod_qlair'
abbr -a -- :prod_v2 'export AWS_PROFILE=prod_v2_qlair'
abbr -a -- :pwd 'pwd | pb'
abbr -a -- :py python
abbr -a -- :q clear
abbr -a -- :ql 'cd ~/qlair'
abbr -a -- :rf 'pnpm run format'
abbr -a -- :sand 'export AWS_PROFILE=sandbox'
abbr -a -- :si 'pacman -Si'
abbr -a -- :sw swaymsg
abbr -a -- :syu 'sudo pacman -Syu'
abbr -a -- :t 'tmux attach -t'
abbr -a -- :tr 'toolbox run'
abbr -a -- :v pipenv
abbr -a -- :vr 'pipenv run'
abbr -a -- :vrf 'pipenv run format'
abbr -a -- :vrl 'pipenv run local'
abbr -a -- :vrt 'pipenv run tests'
abbr -a -- :vs 'pipenv shell'
abbr -a -- :w wezterm
abbr -a -- :wr 'wezterm cli set-tab-title'
abbr -a -- :xt emacsclient\ -t\ -a\ \'\'\ --
abbr -a -- b bat
abbr -a -- bt rofi-bluetooth
abbr -a -- c cargo
abbr -a -- cleancontainers 'docker rm -v (docker ps -a -q -f status=exited)'
abbr -a -- cleanimages 'docker rmi (docker images -q -f dangling=true)'
abbr -a -- cm chezmoi
abbr -a -- covlet 'pandoc --pdf-engine=xelatex --template=moderncv.tex source/letter.md -o output/coverletter-(git rev-parse --abbrev-ref HEAD).pdf'
abbr -a -- current pwd\ \|\ awk\ -F\ \'/\'\ \ \'\{print\ \$NF\}\'
abbr -a -- d docker
abbr -a -- dc 'docker compose'
abbr -a -- dce 'docker compose exec'
abbr -a -- dcr 'docker compose run'
abbr -a -- dk 'docker kill'
abbr -a -- dps 'docker ps'
abbr -a -- dpsa 'docker ps -a'
abbr -a -- dud 'du -sh * | sort -rh'
abbr -a -- e nvim
abbr -a -- fsh 'flatpak-spawn --host'
abbr -a -- g git
abbr -a -- ga 'git add -A'
abbr -a -- gau 'git add -u'
abbr -a -- gb 'git branch'
abbr -a -- gba 'git branch -a'
abbr -a -- gbm 'git branch --merged'
abbr -a -- gbsu 'git branch --set-upstream-to origin/(git rev-parse --abbrev-ref HEAD)'
abbr -a -- gc 'git commit'
abbr -a -- gca 'git commit --amend'
abbr -a -- gcb 'git clone-bare'
abbr -a -- gch 'git checkout'
abbr -a -- gcm 'git commit -m'
abbr -a -- gcp 'git cherry-pick'
abbr -a -- gd 'git diff'
abbr -a -- gdel 'git branch -d'
abbr -a -- gds 'git diff --staged'
abbr -a -- gf 'git fetch'
abbr -a -- gl 'git log --oneline -n 40'
abbr -a -- gll 'git log --graph --oneline --abbrev-commit --decorate --all'
abbr -a -- glog 'git log --oneline'
abbr -a -- gmm 'git merge main'
abbr -a -- gnew 'git checkout -b'
abbr -a -- gp 'git pull'
abbr -a -- gpp 'git push'
abbr -a -- gpr 'git pull --rebase'
abbr -a -- gpsu 'git push --set-upstream origin'
abbr -a -- grpo 'git remote prune origin'
abbr -a -- gsd 'git stash show -p'
abbr -a -- gsh 'git stash'
abbr -a -- gsl 'git stash list'
abbr -a -- gst 'git status'
abbr -a -- gtrack 'git checkout --track'
abbr -a -- guntrack 'git rm -r --cached'
abbr -a -- gwt 'git worktree'
abbr -a -- gwta 'git worktree add'
abbr -a -- gwtl 'git worktree list'
abbr -a -- gwtr 'git worktree remove'
abbr -a -- ids 'cat seeds.txt | fzf --bind \'ctrl-v:execute-silent(echo {2} | wl-copy)+accept,enter:execute-silent(echo {2} | wl-copy)\''
abbr -a -- ipy ipython
abbr -a -- j just
abbr -a -- lb libinput-gestures
abbr -a -- lg 'l --git'
abbr -a -- lgg 'l --grid'
abbr -a -- lti 'lt insights/ InsightEngine/'
abbr -a -- m mix
abbr -a -- mang 'python manage.py'
abbr -a -- moon 'curl wttr.in/moon'
abbr -a -- mux tmuxinator
abbr -a -- myip 'curl ifconfig.co'
abbr -a -- n nnn
abbr -a -- na 'notify audio'
abbr -a -- nd nextd
abbr -a -- nv nvim
abbr -a -- pc pre-commit
abbr -a -- pca 'pre-commit run --all-files'
abbr -a -- pd podman
abbr -a -- pdc podman-compose
abbr -a -- pdce 'podman-compose exec'
abbr -a -- pdcr 'podman-compose run'
abbr -a -- pdk 'podman kill'
abbr -a -- pdps 'podman ps'
abbr -a -- pdpsa 'podman ps -a'
abbr -a -- pip 'python -m pip'
abbr -a -- pipi 'python -m pip install'
abbr -a -- pm pnpm
abbr -a -- pmr 'pnpm run'
abbr -a -- pmrd 'pnpm run dev'
abbr -a -- pmrf 'pnpm run format'
abbr -a -- pmrg 'pnpm run generate-client'
abbr -a -- pyhton python
abbr -a -- pyhttp 'python -m http.server'
abbr -a -- rbmaster 'git rebase master'
abbr -a -- ripy ipython\ --ipython-dir\ .ipython/\ --profile=\(pwd\ \|\ awk\ -F\ \"/\"\ \'\{print\ \$NF\}\'\)
abbr -a -- rmimages 'docker rmi (docker images -q -f dangling=true)'
abbr -a -- rt 'flatpak-spawn --host podman-compose exec api pipenv run tests'
abbr -a -- t tmux
abbr -a -- tds 'trash .DS_Store'
abbr -a -- tmp 'cd /tmp'
abbr -a -- venv 'python -m venv'
abbr -a -- weather 'curl wttr.in'
abbr -a -- wl wally-cli
abbr -a -- wlc wl-copy
abbr -a -- wm swaymsg
abbr -a -- z zellij
abbr -a -- zv 'nvim (z | cut -d: -f1-2)'
