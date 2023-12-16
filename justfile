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
