{ pkgs, ... }:
{
  home.packages = with pkgs; [ vdirsyncer ];

  home.file = {
    ".vdirsyncer/config" = {
      source = ../../../../config/vdirsyncer/config;
    };
  };
}
