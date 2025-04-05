default:
  @just --choose

alias f := format
format:
  nix fmt

alias sw := switch
switch:
  sudo nixos-rebuild switch --show-trace --fast --flake .#mithlond

alias up := update
update:
  nix flake update

hm *cmd="switch":
  NIXPKGS_ALLOW_UNFREE=1 nix run home-manager -- --flake . --impure {{cmd}} 

gc days="50":
  sudo nix store gc
  nix-collect-garbage --delete-older-than {{days}}d
  sudo nix-collect-garbage --delete-older-than {{days}}d

# Symlink non-home-manager dotfiles
dots:
  ./dotfiles/symlink.nu
