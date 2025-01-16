{ pkgs, ... }: {
  config = {
    home.file.".config/git/ignore".source = ./ignore;

    home.packages = with pkgs; [ lazygit ];

    programs.git = {
      enable = true;
      userName = "Brian Bonsignore";
      userEmail = "bonsignore.brian@gmail.com";
      aliases = {
        a = "add";
        aa = "add --all";

        b = "branch";
        ba = "branch --all";
        bm = "branch --merged";
        bn = "branch --show-current";

        c = "commit";
        ca = "commit --amend";
        cm = "commit --message";

        # cd to worktree root (repo root in normal clone)
        # cd = "!cd $(git worktree list | rg $(git branch --show-current) | awk '{print $1}')";

        cp = "cherry-pick";
        cpa = "cherry-pick --abort";
        cpc = "cherry-pick --continue";

        # ~/.local/bin/git-clone-bare 
        clone-bare = "git-clone-bare";

        # Diff $1=branch against its origin version
        do = ''!f() { branch=$\{1:-main\} git diff "$branch" "origin/$branch"; }; f'';
        # Summary diff $1=branch against its origin version
        dos = ''!f() { branch=$\{1:-main\} git diff --stat "$branch" "origin/$branch"; }; f'';

        f = "fetch";

        g = "grep";

        jm = "jump merge";
        last = "log -1 HEAD";
        l =
          "log --oneline -n 40 --date=short --boundary --pretty=format:'%Cgreen%ad %C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cblue[%aN]%Creset %Cblue'";
        ll = "log --graph --oneline --abbrev-commit --decorate --all";

        m = "merge";
        ma = "merge --abort";

        new = "switch --create";

        p = "pull";
        pp = "push";

        st = "status";

        ti = "stash --include-untracked";
        tp = "stash pop";
        td = "stash show -p";
        tl = "stash list";

        unstage = "reset HEAD --";

        w = "switch";

        wt = "worktree";
        wta = "worktree add";
        wtl = "worktree list";
        wtr = "worktree remove";
      };
      extraConfig = {
        core = {
          editor = "nvim";
          pager = "delta";
        };
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        interactive.diffFilter = "delta --color-only";
        worktree.guessRemote = true;
        # https://github.com/jesseduffield/lazygit/blob/master/docs/Stacked_Branches.md
        rebase.updateRefs = true;
        rerere.enabled = true;
        color.decorate = {
          head = "bold white";
          branch = "bold magenta";
          remotebranch = "blue";
          tag = "bold red";
        };

        delta = {
          navigate = true;
          side-by-side = true;
          features = "line-numbers decorations";
          whitespace-error-style = "22 reverse";
          decorations = {
            "file-style" = "bold yellow ul";
            "file-decoration-style" = "none";
          };
        };
      };
    };
  };
}
