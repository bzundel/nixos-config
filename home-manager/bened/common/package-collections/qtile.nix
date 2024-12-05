{ pkgs, ... }:
{
  imports = [ ../programs/kitty.nix ];

  home.packages = with pkgs; [
    dmenu
    slock
    networkmanagerapplet
  ];

  home.file = {
    ".config/qtile" = {
      source = ../../../../config/qtile;
      recursive = true;
    };

    ".config/qtile/autostart.sh" = {
      source = ../../../../config/qtile/autostart.sh;
      executable = true;
    };
  };
}
