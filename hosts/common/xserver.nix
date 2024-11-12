{ pkgs, ...}:
{
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.windowManager.dwm = {
    enable = true;

    package = pkgs.dwm.override {
        patches = [
          (pkgs.fetchpatch {
            url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
            hash = "sha256-mrHh4o9KBZDp2ReSeKodWkCz5ahCLuE6Al3NR2r2OJg=";
          })
        ];
      };
    };

  services.xserver.videoDrivers = [ "intel" ];

  services.xserver.xkb = {
    layout = "us,de";
    variant = "";
  };

  services.libinput.enable = true;
}
