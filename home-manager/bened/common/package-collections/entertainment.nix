{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify
    calibre
    newsboat
    sgt-puzzles
  ];
}
