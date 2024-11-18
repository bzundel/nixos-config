{ pkgs, ... }:
{
  imports = [
    ../programs/newsboat.nix
    ../programs/tmux.nix
    ../programs/vdirsyncer.nix
    ../programs/khal.nix
    ../programs/vim.nix
    ../programs/zsh.nix
    ../programs/git.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    obsidian
    mpv
    yt-dlp
    rclone
    xclip
    unzip
    file
    remmina
    fzf
    gnupg
    kdePackages.kleopatra
    zathura
    khal
    pass
    vdirsyncer
    gimp
    alsa-utils
    flameshot
    qutebrowser
  ];
}
