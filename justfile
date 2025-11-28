default:
  @just --choose

alias f := format
format:
  nix fmt

alias sw := switch
switch:
  sudo nixos-rebuild switch --fast --flake .#mithlond

alias up := update
update:
  nix flake update

hm *cmd="switch":
  NIXPKGS_ALLOW_UNFREE=1 nix run home-manager -- --flake . --impure -b hm-backup {{cmd}} 

gc days="50":
  nix store gc
  nix-collect-garbage --delete-older-than {{days}}d

# Symlink non-home-manager dotfiles
dots:
  ./dotfiles/symlink.nu
