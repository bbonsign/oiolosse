format:
  nix fmt *.nix

rebuild:
  sudo nixos-rebuild switch --flake .#nixos

update:
  nix flake update
