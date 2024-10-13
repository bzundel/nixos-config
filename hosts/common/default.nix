{ inputs, outputs, ... }:
{
  imports = [
    ./fonts.nix
    ./gnome.nix
    ./localization.nix
    ./nix.nix
    ./postgresql.nix
    ./programs.nix
    ./security.nix
    ./sound.nix
    ./users.nix
    ./work.nix
    ./xserver.nix
  ];

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

  services.printing.enable = true;

  hardware.opengl.enable = true;

  networking.networkmanager = {
    enable = true;
    dns = "default";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
