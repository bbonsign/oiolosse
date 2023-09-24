{pkgs, ...}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [ gcc rnix-lsp sumneko-lua-language-server ];
  };
}
