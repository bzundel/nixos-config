{
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.windowManager.dwm.enable = true;

  services.xserver.videoDrivers = [ "intel" ];

  services.xserver.xkb = {
    layout = "us,de";
    variant = "";
  };

  services.libinput.enable = true;
}
