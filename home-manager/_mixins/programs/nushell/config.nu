
source ~/.config/nushell/scripts/themes/nu-themes/tokyo-night.nu
source ~/.cache/carapace/init.nu

# config scripts/: module
use : *

$env.config = {
    # aka, show the nushell start message
    show_banner: false,

    completions: {
      algorithm: fuzzy
    },

    history: {max_size: 10000},

    cursor_shape: {
        emacs: inherit      # block, underscore, line (line is the default)
        vi_insert: line     # block, underscore, line (block is the default)
        vi_normal: block    # block, underscore, line (underscore is the default)
    },

    # https://github.com/nushell/nushell/issues/5552#issuecomment-2077047961
    keybindings: [ 
      {
        name: abbr
        modifier: control
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
          { send: menu name: abbr_menu }
          { edit: insertchar, value: ' '}
        ]
      },
      {
        name: fuzzy_file
        modifier: control
        keycode: char_t
        mode: emacs
        event: {
          send: executehostcommand
          cmd: "commandline edit --insert (fzf --layout=reverse)"
        }
      },
      {
        name: fuzzy_git_status
        modifier: control_alt
        keycode: char_s
        mode: emacs
        event: {
          send: executehostcommand
          cmd: "commandline edit --insert (fg status)"
        }
      },
      {
        name: fuzzy_git_branch
        modifier: control_alt
        keycode: char_b
        mode: emacs
        event: {
          send: executehostcommand
          cmd: "commandline edit --insert (fg branches)"
        }
      },
      {
        name: fuzzy_git_branch_all
        modifier: control_alt
        keycode: char_g
        mode: emacs
        event: {
          send: executehostcommand
          cmd: "commandline edit --insert (fg branches --all)"
        }
      },
      # {
      #   name: fzf_tmux
      #   modifier: control
      #   keycode: char_t
      #   mode: emacs
      #   event: [
      #     {
      #       edit: InsertString,
      #       value: "fzf-tmux"
      #     },
      #     # {
      #     #   send: Enter
      #     # }
      #   ]
      # }
    ],

    menus: [
      {
        name: abbr_menu
        only_buffer_difference: false
        marker: ""
        type: {
          layout: columnar
          columns: 1
          col_width: 20
          col_padding: 2
        }
        style: {
          text: green
          selected_text: green_reverse
          description_text: yellow
        }
        source: { |buffer, position|
          scope aliases
          | where name == ($buffer | str trim)
          | each { |it| {value: $it.expansion }}
        }
      }
    ]
}

use /home/bbonsign/.cache/starship/init.nu

source /home/bbonsign/.cache/carapace/init.nu

source /home/bbonsign/.cache/atuin/init.nu

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        /nix/store/3lv7pgadn5b587s69y23lpj90170q0n5-direnv-2.35.0/bin/direnv export json
        | from json --strict
        | default {}
        | items {|key, value|
            let value = do (
                $env.ENV_CONVERSIONS?
                | default {}
                | get -i $key
                | get -i from_string
                | default {|x| $x}
            ) $value
            return [ $key $value ]
        }
        | into record
        | load-env
    }
)

alias ... = cd ../..
alias .... = cd ../../..
alias :b = cd -
alias :bin = cd ~/.local/bin
alias :cm = cmatrix -absCcyan
alias :g = lazygit
alias :gb = lazygit branch
alias :gl = lazygit log
alias :gs = lazygit status
alias :gt = lazygit stash
alias :k = kitty
alias :ke = kitty +edit-config
alias :ld = l --only-dirs
alias :ln = l -s newest
alias :nf = neofetch
alias :r = rpm-ostree
alias :rs = rpm-ostree status
alias :t = tmux attach -t
alias b = bat
alias bx = cd ~/Dropbox
alias cdr = cd (git rev-parse --show-toplevel)
alias cl = clear
alias cleancontainers = docker rm -v (docker ps -a -q -f status=exited)
alias cleanimages = docker rmi (docker images -q -f dangling=true)
alias conf = cd ~/.config
alias cp = cp -v
alias d = docker
alias dbx = distrobox
alias dc = docker compose
alias dce = docker compose exec
alias dcr = docker compose run
alias dk = docker kill
alias dl = cd ~/Downloads
alias dps = docker ps
alias dpsa = docker ps -a
alias e = nvim
alias eqf = nvim --cmd 'copen' -q <(rg --column --line-number --no-heading)
alias g = git
alias ga = git add
alias gaa = git add -A
alias gau = git add -u
alias gb = git branch
alias gba = git branch -a
alias gbm = git branch --merged
alias gbsu = git branch --set-upstream-to origin/(git rev-parse --abbrev-ref HEAD)
alias gc = git commit
alias gca = git commit --amend
alias gcb = git clone-bare
alias gcd = cd (git rev-parse --show-toplevel)
alias gch = git checkout
alias gcm = git commit -m
alias gcp = git cherry-pick
alias gd = git diff
alias gdel = git branch -d
alias gds = git diff --staged
alias gf = git fetch
alias gl = git log --oneline -n 40 --date=short --boundary --pretty=format:'%Cgreen%ad %C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cblue[%aN]%Creset %Cblue'
alias gll = git log --graph --oneline --abbrev-commit --decorate --all
alias glog = git log --oneline
alias gm = git merge
alias gma = git merge --abort
alias gmm = git merge main
alias gnew = git checkout -b
alias gp = git pull
alias gpp = git push
alias gpsu = git push --set-upstream origin
alias gr = git remote -v
alias grpo = git remote prune origin
alias gst = git status
alias gt = git stash
alias gtd = git stash show -p
alias gti = git stash --include-untracked
alias gtl = git stash list
alias gtp = git stash pop
alias gtrack = git checkout --track
alias guntrack = git rm -r --cached
alias gw = git switch
alias gwt = git worktree
alias gwta = git worktree add
alias gwtl = git worktree list
alias gwtr = git worktree remove
alias icat = kitty +kitten icat
alias ipy = ipython
alias j = just
alias jz = just --choose
alias l = eza --all --long --group-directories-first --icons
alias lg = l --git
alias lgg = l --grid
alias ll = eza -l --group-directories-first
alias lt = eza --all --long --group-directories-first --git-ignore --icons --tree
alias lt2 = eza --all --long --group-directories-first --git-ignore --icons --tree -L2
alias lt3 = eza --all --long --group-directories-first --git-ignore --icons --tree -L3
alias lt4 = eza --all --long --group-directories-first --git-ignore --icons --tree -L4
alias m = mix
alias mv = mv -v
alias myip = curl ifconfig.co
alias nv = nvim
alias opnew = open (eza -rs newest | head -1)
alias pd = podman
alias pdc = podman compose
alias pdce = podman compose exec
alias pdcr = podman compose run
alias pdk = podman kill
alias pdps = podman ps
alias pdpsa = podman ps -a
alias pip = python -m pip
alias pipi = python -m pip install
alias pyhton = python
alias pyhttp = python -m http.server
alias qf = rg --column --line-number --no-heading
alias rmi = rm -i
alias rmimages = docker rmi (docker images -q -f dangling=true)
alias t = tmux
alias tp = trash put
alias tree = tree --dirsfirst
alias wlc = wl-copy

