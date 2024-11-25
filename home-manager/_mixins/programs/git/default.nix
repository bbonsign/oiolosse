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

        f = "fetch";

        g = "grep";

        last = "log -1 HEAD";
        l =
          "log --oneline -n 40 --date=short --boundary --pretty=format:'%Cgreen%ad %C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cblue[%aN]%Creset %Cblue'";
        ll = "log --graph --oneline --abbrev-commit --decorate --all";

        m = "merge";
        ma = "merge --abort";

        p = "pull";
        pp = "push";

        st = "status";

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
