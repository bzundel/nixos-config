{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      hmconfig = "vim ${config.xdg.configHome}/home-manager/home.nix";
      hmupdate = "home-manager switch";
      nixconfig = "sudo vim /etc/nixos/configuration.nix";
      nixupdate = "sudo nixos-rebuild switch";
      deinit = "echo 'use flake' > .envrc; direnv allow";
    };

    initExtra = ''
      eval "$(direnv hook zsh)"
    '';

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "half-life";
    };
  };
}
