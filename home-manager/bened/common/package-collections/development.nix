{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pgadmin4-desktopmode
    direnv
    elixir
    inotify-tools
    gnumake
    gcc
    python3
    #jetbrains.rider
    #dotnet-sdk_8
    #ghc
  ];
}
