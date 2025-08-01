_:

{
  config = {
    programs.lazygit = {
      enable = true;
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
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never --no-gitconfig";
          };

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
            openMergeTool = "M";
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
            resetCherryPick = "<c-R>";
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
}
