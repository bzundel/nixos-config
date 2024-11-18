{ pkgs, ... }:
{
  programs.gnome-shell = {
    enable = true;

    theme = {
      name = "Yaru-purple-dark";
      package = pkgs.yaru-theme;
    };

    extensions = [
      { package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.vitals; }
      { package = pkgs.unstable.gnomeExtensions.systemd-manager; }
    ];
  };
}
