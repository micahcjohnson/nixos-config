# nixos-config

Configuration for my NixOS system. Set up using `flake-parts` and `import-tree` to automatically import all nix files.

## `modules/` structure

| dir           | purpose                                                      |
| ------------- | ------------------------------------------------------------ |
| `hosts/`      | system configurations (currently only one)                   |
| `users/`      | user home-manager modules (also only one)                    |
| `services/`   | system-level blocks of related config                        |
| `apps/`       | custom derivations                                           |
| `tweaks/`     | small, isolated patches for various issues                   |
| `components/` | units of related config that have both system and user parts |
