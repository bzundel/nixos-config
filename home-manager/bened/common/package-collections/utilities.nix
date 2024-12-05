{ pkgs, ... }:
{
  imports = [
    ../programs/firefox.nix
    ../programs/newsboat.nix
    ../programs/tmux.nix
    ../programs/vdirsyncer.nix
    ../programs/khal.nix
    ../programs/vim.nix
    ../programs/zsh.nix
    ../programs/git.nix
  ];

  home.packages = with pkgs; [
    file
    fzf
    rclone
    mpv
    yt-dlp
    zathura
    pass
    vdirsyncer
    khal
    alsa-utils
    keepassxc
    obsidian
    remmina
    gnupg
    kdePackages.kleopatra
    gimp
    qutebrowser
  ];
}
