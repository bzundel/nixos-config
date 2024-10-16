{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    wget
    vim

    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
