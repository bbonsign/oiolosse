default:
  @just --choose

alias f := format
format:
  @fd -e nix | nix fmt

alias sw := switch
switch:
  sudo nixos-rebuild switch --flake .#nixos

update:
  nix flake update

hm:
  NIXPKGS_ALLOW_UNFREE=1 nix run home-manager -- --flake . --impure switch
