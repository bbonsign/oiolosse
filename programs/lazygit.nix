{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      # to exit immediately if run outside of the Git repository
      notARepository = "quit";
      gui = {
        nerdFontsVersion = "3";
        sidePanelWidth = 0.25;
        theme = { selectedLineBgColor = [ "black" "bold" ]; };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --no-gitconfig";
        };

        os.editPreset = "nvim";

      };
    };
  };
}
