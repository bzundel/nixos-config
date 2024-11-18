{ outputs, ... }:
{
  imports = [ outputs.homeManagerModules.gnome-dash-to-dock ];

  programs.gnome-dash-to-dock = {
    enable = true;

    appearance = {
      extendHeight = true;
      dashMaxIconSize = 32;
      dockPosition = "LEFT";
      shrinkDash = true;
      applyCustomTheme = false;
    };

    behavior = {
      hotKeys = false;
      disableOverviewOnStartup = true;
      dockFixed = true;
    };

    show = {
      mounts = false;
      mountsNetwork = false;
      trash = false;
    };
  };
}
