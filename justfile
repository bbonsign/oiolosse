default:
  @just --choose

alias f := format
format:
  @fd -e nix | nix fmt

alias sw := switch
switch:
  sudo nixos-rebuild switch --flake .#mithlond

update:
  nix flake update

hm *cmd="switch":
  NIXPKGS_ALLOW_UNFREE=1 nix run home-manager -- --flake . --impure {{cmd}}
