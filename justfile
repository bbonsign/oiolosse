default:
  @just --choose

alias f := format
format:
  nix fmt *.nix

switch:
  sudo nixos-rebuild switch --flake .#nixos

update:
  nix flake update
