{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  unstable = inputs.nixpkgs-unstable;
  scripts = inputs.scripts.packages."x86_64-linux".default;
in
{
  imports = [
    ./package-collections/utilities.nix
    ./package-collections/development.nix
    ./package-collections/communication.nix
    ./package-collections/entertainment.nix
    ./package-collections/qtile.nix
    ./services/caffeine.nix
    ./services/dunst.nix
    ./services/kdeconnect.nix
    ./systemd/rclone-onedrive.nix
    ./systemd/vdirsyncer-sync.nix
  ];

  home.packages = [ scripts ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  home.username = "bened";
  home.homeDirectory = "/home/bened";

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
