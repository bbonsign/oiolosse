# Repository guidance

This is a personal NixOS and Home Manager flake for the `mithlond` host and
`bbonsign` home configuration.

## Layout

- `flake.nix` defines inputs and imports the module tree from `modules/`.
- `modules/hosts/` contains host configuration; `modules/homes/` assembles Home
  Manager configuration; reusable configuration belongs in `modules/features/`.
- `dotfiles/` contains application configuration and scripts, linked by
  `dotfiles/symlink.nu` (`mise run dots`).
- Modules are discovered with `import-tree`; follow existing module naming and
  `flake.nixosModules`/`flake.homeModules` patterns.

## Working conventions

- Keep changes scoped and preserve machine- or user-specific values unless the
  task explicitly requires changing them.
- Format with `mise run format` (`nix fmt`).
- Validate Nix changes with `mise run check_flake` (`nix flake check`).
- Do not run activation commands (`mise run switch` or `mise run hm`) unless
  explicitly requested; they modify the live system or home environment.
- Do not update `flake.lock` unless dependency updates are part of the task.
