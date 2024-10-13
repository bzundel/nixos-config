{
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  networking.hostName = "corapad";
}
