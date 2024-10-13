{ pkgs, ... }:
{
  fonts.packages = with pkgs; [ ubuntu_font_family ];
}
