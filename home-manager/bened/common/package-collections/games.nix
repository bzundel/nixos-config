{ pkgs, ... }:
{
  home.packages = with pkgs; [
    steam
    lutris
    prismlauncher
    wineWowPackages.stable
    winetricks
  ];
}
