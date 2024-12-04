{
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  networking.hostName = "corapad";

  services.libinput = {
    enable = true;

    touchpad = {
      tapping = false;
    };
  };
}
