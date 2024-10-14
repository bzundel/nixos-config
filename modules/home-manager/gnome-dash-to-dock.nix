# FIXME rewrite the descriptions
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.gnome-dash-to-dock;
in
{
  options.programs.gnome-dash-to-dock = {
    enable = mkEnableOption "GNOME dash to dock extension customization";

    extendHeight = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not to use panel mode.
      '';
    };

    dockPosition = mkOption {
      type = types.str;
      default = "LEFT";
      example = "BOTTOM";
      description = ''
        Position of the dock. One of "LEFT", "TOP", "RIGHT" or "BOTTOM".
      '';
    };

    dockFixed = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to fix the dock position or use intelligent autohide.
      '';
    };

    hotKeys = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Use Super+{0..9} to launch applications.
      '';
    };

    applyCustomTheme = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to use built-in theme.
      '';
    };

    shrinkDash = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Shrink the dash icons to save space.
      '';
    };

    disableOverviewOnStartup = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable showing overview on startup.
      '';
    };

    dashMaxIconSize = mkOption {
      type = types.int;
      default = 48;
      description = ''
        Maximum size of the icons in dock.
      '';
    };

    showMounts = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to show mounted drives in the dock.
      '';
    };

    showMountsNetwork = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to show mounted network drives in the dock.
      '';
    };

    showTrash = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to show a trash icon in the dock.
      '';
    };
  };

  config = mkIf cfg.enable {
    dconf.settings."org/gnome/shell/extensions/dash-to-dock" = {
      extend-height = cfg.extendHeight;
      dock-fixed = cfg.dockFixed;
      dock-position = cfg.dockPosition;
      hot-keys = cfg.hotKeys;
      apply-custom-theme = cfg.applyCustomTheme;
      custom-theme-shrink = cfg.shrinkDash;
      disable-overview-on-startup = cfg.disableOverviewOnStartup;
      dash-max-icon-size = cfg.dashMaxIconSize;
      show-mounts = cfg.showMounts;
      show-mounts-network = cfg.showMountsNetwork;
      show-trash = cfg.showTrash;
    };

    home.packages = [ pkgs.gnomeExtensions.dash-to-dock ];
  };
}
