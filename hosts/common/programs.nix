{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    wget
    vim

    dmenu
    st
    slstatus
    slock

    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.slock.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
