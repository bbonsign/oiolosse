_: {
  config = {
    programs.fd = {
      enable = true;
      ignores = [

        # Global ignore file for fd command
        # Most of these are just to ignore the really large home directory on my Mac that makes fzf unusable
        # Uses gitignore syntax

        "Downloads/*"
        "Applications"
        "Library"
        "node_modules"
        "go"
        "site-packages"
        "zig-cache"

        "deps"
        "_build"

        "!.dotfiles"
        "!.config"
        "!.bin"
      ];
    };
  };
}
