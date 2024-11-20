{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.terminus_font_ttf;
      name = "Terminus";
    };

    settings = {
      enable_audio_bell = false;
    };
  };
}
