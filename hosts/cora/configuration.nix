{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/optional/desktop/gnome.nix
  ];

  networking.hostName = "cora";
}
