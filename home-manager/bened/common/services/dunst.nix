{ pkgs, ... }:
{
  services.dunst = {
    enable = true;

    iconTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru-purple-dark";
    };

    settings = {
      global = {
        origin = "top-right";
      };
    };
  };
}
