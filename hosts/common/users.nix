{ pkgs, ... }:
{
  users.users.bened = {
    isNormalUser = true;
    description = "Benedikt Zundel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = [ ];
  };
}
