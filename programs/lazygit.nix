{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      # to exit immediately if run outside of the Git repository
      notARepository = "quit";
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --no-gitconfig";
        };

        os.editPreset = "nvim";

        gui = {
          showIcons = true;
          sidePanelWidth = "0.25";
        };
      };
    };
  };
}
