{ pkgs, ... }:
{
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;

  services.xserver.videoDrivers = [ "intel" ];

  services.xserver.xkb = {
    layout = "us,de";
    variant = "";
  };
}
