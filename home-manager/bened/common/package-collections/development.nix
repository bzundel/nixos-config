{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.rider
    pgadmin4-desktopmode
    direnv
    dotnet-sdk_8
    ghc
    elixir
    inotify-tools
    gnumake
    gcc
    python3
  ];
}
