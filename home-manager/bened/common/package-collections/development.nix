{ pkgs, ... }:
{
  imports = [
    ../programs/vscode.nix
  ];

  home.packages = with pkgs; [
    direnv
    inotify-tools
    python3
    elixir
    gnumake
    gcc
    just
  ];
}
