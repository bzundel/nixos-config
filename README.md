# NixOS cora machine configurations

Flake-based system configuration based on https://github.com/Misterio77/nix-starter-configs

# Fixes
- NixOS config needs less programs. More should be managed by home-manager
- Remove kde connect maybe?

# To implement
- Create derivation for scripts that install into `/bin`

## Qtile
- Widget that compares local and upstream for changes (nix state)
- Fork and expand battery widget to allow display of multiple batteries combined
    - Should take into account total capacity as a weight for total percentage
