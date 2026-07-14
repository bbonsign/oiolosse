{inputs, pkgs, ...}: {
  flake.homeModules.vcs = {pkgs,...}: {

    config = {
      home.packages = [
        inputs.jjui.packages.x86_64-linux.jjui
        pkgs.jujutsu

        pkgs.lazygit
        pkgs.git-extras
        pkgs.gh # GitHub cli
      ];

      home.file.".config/git/ignore".source = ./ignore;

      programs.git = {
        enable = true;
        signing.format = "openpgp";
        includes = [
          {
            condition = "gitdir:~/mh/";
            contents = {
              user.email = "brian.bonsignore@mann-hummel.com";
              user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDusQHZwJ2pMj91kAQXLpbZmPSzSgL9xpKrcpjnq7l2v brian.bonsignore@mann-hummel.com";
              gpg.format = "ssh";
              gpg.ssh.program = "/opt/1Password/op-ssh-sign";
              gpg.ssh.allowedSignersFile = builtins.toString ./allowed_signers;
              commit.gpgsign = true;
            };
          }
        ];
        settings = {
          user = {
            name = "Brian Bonsignore";
            email = "bonsignore.brian@gmail.com";
          };
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
            dark = true;
            features = "default-features";
            default-features = "line-numbers decorations split-view";
            navigate = true;
            tabs = 2;
            whitespace-error-style = "22 reverse";
            split-view = {
              side-by-side = true;
            };
            non-split-view = {
              side-by-side = false;
            };
            decorations = {
              "file-style" = "bold yellow ul";
              "file-decoration-style" = "none";
              # Tokyonight extra
              "minus-style" = "syntax #37222c";
              "minus-non-emph-style" = "syntax #37222c";
              "minus-emph-style" = "syntax #713137";
              "minus-empty-line-marker-style" = "syntax #37222c";
              "line-numbers-minus-style" = "#914c54";
              "plus-style" = "syntax #20303b";
              "plus-non-emph-style" = "syntax #20303b";
              "plus-emph-style" = "syntax #2c5a66";
              "plus-empty-line-marker-style" = "syntax #20303b";
              "line-numbers-plus-style" = "#449dab";
              "line-numbers-zero-style" = "#3b4261";
            };
          };
          alias = {
            # https://duncanlock.net/blog/2021/11/01/git-up-alias-that-works-for-any-default-branch/
            head-branch = ''!git remote show origin | grep 'HEAD branch' | cut -d' ' -f5'';
            up = ''!git switch $(git head-branch) && git fetch --all --prune --progress && git pull'';

            a = "add";
            aa = "add --all";
            au = "add -u";

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

            mv = "branch --move";

            new = "switch --create";

            p = "pull";
            pp = "push";

            ra = "rebase --abort";
            rc = "rebase --continue";
            ri = "rebase --interactive";

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
        };
      };

      programs.lazygit = {
        enable = true;
        enableBashIntegration = false;
        settings = {
          # to exit immediately if run outside of the Git repository
          notARepository = "quit";
          gui = {
            nerdFontsVersion = "3";
            sidePanelWidth = 0.25;
            theme = {
              selectedLineBgColor = [ "black" "bold" ];
            };
            # Tokyonight extra
            # theme = {
            #   selectedLineBgColor = [ "black" "bold" ];
            #   activeBorderColor = [ "#ff9e64" "bold" ];
            #   inactiveBorderColor = [ "#7dcfff" ];
            #   searchingActiveBorderColor = [ "#ff9e64" "bold" ];
            #   optionsTextColor = [ "#7aa2f7" ];
            #   # selectedLineBgColor = [ "#283457" ];
            #   cherryPickedCommitFgColor = [ "#7aa2f7" ];
            #   cherryPickedCommitBgColor = [ "#bb9af7" ];
            #   markedBaseCommitFgColor = [ "#7aa2f7" ];
            #   markedBaseCommitBgColor = [ "#e0af68" ];
            #   unstagedChangesColor = [ "#db4b4b" ];
            #   defaultFgColor = [ "#c0caf5" ];
            # };
          };
          git = {
            pagers = [
              {
                colorArg = "always";
                pager = "delta --dark --paging=never --no-gitconfig";
              }
            ];

            autoFetch = false;

            os.editPreset = "nvim";
          };
          keybinding = {
            universal = {
              quit = "q";
              quit-alt1 = "<c-c>"; # alternative/alias of quit
              return =
                "<esc>"; # return to previous menu, will quit if there"s nowhere to return;
              quitWithoutChangingDirectory = "Q";
              togglePanel = "<tab>"; # goto the next panel;
              prevItem = "<up>"; # go one line up;
              nextItem = "<down>"; # go one line down;
              prevItem-alt = "k"; # go one line up;
              nextItem-alt = "j"; # go one line down;
              prevPage = ","; # go to next page in list;
              nextPage = "."; # go to previous page in list;
              gotoTop = "<"; # go to top of list;
              gotoBottom = ">"; # go to bottom of list;
              scrollLeft = "L"; # scroll left within list view;
              scrollRight = "L"; # scroll right within list view;
              prevBlock = "<left>"; # goto the previous block / panel;
              nextBlock = "<right>"; # goto the next block / panel;
              prevBlock-alt = "K"; # goto the previous block / panel;
              nextBlock-alt = "J"; # goto the next block / panel;
              jumpToBlock = [ "1" "2" "3" "4" "5" ]; # goto the Nth block / panel;
              nextMatch = "n";
              prevMatch = "N";
              optionMenu = "?"; # show help menu;
              optionMenu-alt1 = "<disabled>"; # show help menu;
              select = "<space>";
              goInto = "<enter>";
              # goInto = "l";
              openRecentRepos = "<c-r>";
              confirm = "<enter>";
              # confirm = "y";
              remove = "d";
              new = "n";
              edit = "e";
              openFile = "o";
              scrollUpMain = "<pgup>"; # main panel scroll up;
              scrollDownMain = "<pgdown>"; # main panel scroll down;
              scrollUpMain-alt1 = "<disabled>"; # main panel scroll up;
              scrollDownMain-alt1 = "<disabled>"; # main panel scroll down;
              scrollUpMain-alt2 = "<c-u>"; # main panel scroll up;
              scrollDownMain-alt2 = "<c-d>"; # main panel scroll down;
              executeShellCommand = ":";
              createRebaseOptionsMenu = "m";
              pushFiles = "P";
              pullFiles = "p";
              refresh = "R";
              createPatchOptionsMenu = "<disabled>";
              nextTab = "]";
              prevTab = "[";
              nextScreenMode = "=";
              prevScreenMode = "-";
              undo = "z";
              redo = "<c-z>";
              filteringMenu = "<c-s>";
              diffingMenu = "W";
              diffingMenu-alt = "<c-e>"; # deprecated;
              copyToClipboard = "<c-o>";
              submitEditorText = "<enter>";
              extrasMenu = "@";
              toggleWhitespaceInDiffView = "<c-w>";
              increaseContextInDiffView = "}";
              decreaseContextInDiffView = "{";
              toggleRangeSelect = "v";
              rangeSelectUp = "<s-up>";
              rangeSelectDown = "<s-down>";
            };
            status = {
              checkForUpdate = "u";
              recentRepos = "<enter>";
            };
            files = {
              commitChanges = "c";
              commitChangesWithoutHook =
                "w"; # commit changes without pre-commit hook;
              amendLastCommit = "A";
              commitChangesWithEditor = "C";
              findBaseCommitForFixup = "<c-f>";
              confirmDiscard = "x";
              ignoreFile = "i";
              refreshFiles = "r";
              stashAllChanges = "s";
              viewStashOptions = "S";
              toggleStagedAll = "a"; # stage/unstage all;
              viewResetOptions = "D";
              fetch = "f";
              toggleTreeView = "`";
              openMergeOptions = "M";
              openStatusFilter = "<c-b>";
              collapseAll = "_";
              expandAll = "+";
            };
            branches = {
              createPullRequest = "o";
              viewPullRequestOptions = "O";
              checkoutBranchByName = "c";
              forceCheckoutBranch = "F";
              rebaseBranch = "r";
              renameBranch = "R";
              mergeIntoCurrentBranch = "M";
              viewGitFlowOptions = "i";
              fastForward = "f"; # fast-forward this branch from its upstream;
              createTag = "T";
              pushTag = "P";
              setUpstream = "u"; # set as upstream of checked-out branch;
              fetchRemote = "f";
            };
            commits = {
              squashDown = "s";
              renameCommit = "r";
              renameCommitWithEditor = "R";
              viewResetOptions = "g";
              markCommitAsFixup = "f";
              createFixupCommit = "F"; # create fixup commit for this commit;
              squashAboveCommits = "S";
              moveDownCommit = "<c-j>"; # move commit down one;
              moveUpCommit = "<c-k>"; # move commit up one;
              amendToCommit = "A";
              amendAttributeMenu = "a";
              pickCommit = "p"; # pick commit (when mid-rebase);
              revertCommit = "t";
              cherryPickCopy = "C";
              pasteCommits = "V";
              tagCommit = "T";
              checkoutCommit = "<space>";
              copyCommitMessageToClipboard = "<c-y>";
              openLogMenu = "<c-l>";
              viewBisectOptions = "b";
            };
            stash = {
              popStash = "<c-p>";
              renameStash = "r";
            };
            commitFiles = { checkoutCommitFile = "c"; };
            main = {
              toggleSelectHunk = "a";
              pickBothHunks = "b";
            };
            submodules = {
              init = "i";
              update = "u";
              bulkMenu = "b";
            };
            commitMessage = { commitMenu = "<c-o>"; };
            amendAttribute = {
              addCoAuthor = "c";
              resetAuthor = "a";
              setAuthor = "A";
            };
          };
        };
      };

    };
  };
}
