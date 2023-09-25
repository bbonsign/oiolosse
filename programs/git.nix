{pkgs , ... }:

{
  home.file.".config/git/ignore".source = ../dotfiles/dot_config/git/ignore;

  home.packages = with pkgs; [
    lazygit
  ];

  programs.git = {
    enable = true;
    userName = "Brian Bonsignore";
    userEmail = "bonsignore.brian@gmail.com";
    aliases = {
      ca = "commit --amend";
      clone-bare = "git-clone-bare";
      last = "log -1 HEAD";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      st = "status";
      unstage = "reset HEAD --";
    };
    extraConfig = {
      core ={
        editor="nvim";
        pager="delta";
      };
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      interactive.diffFilter = "delta --color-only";
      worktree.guessRemote=true;
      color.decorate ={
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
        decorations ={
          "file-style" = "bold yellow ul";
          "file-decoration-style" = "none";
        };
      };
    };
  };
}
