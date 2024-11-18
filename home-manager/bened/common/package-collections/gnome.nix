{ pkgs, ... }:
{
  imports = [
    ../programs/gnome-shell.nix
    ../programs/gnome-terminal.nix
    ../programs/gnome-dash-to-dock.nix
  ];

  home.packages = with pkgs; [ gnome.gnome-tweaks ];

  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru";
      size = 24;
    };

    font = {
      package = pkgs.ubuntu_font_family;
      name = "Ubuntu";
      size = 11;
    };

    iconTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru-purple-dark";
    };

    theme = {
      package = pkgs.yaru-theme;
      name = "Yaru-purple-dark";
    };
  };
}
