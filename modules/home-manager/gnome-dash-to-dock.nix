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
  meta.maintainers = [ maintainers.bzundel ];

  options.programs.gnome-dash-to-dock = {
    enable = mkEnableOption "GNOME dash to dock extension customization";

    appearance = mkOption {
      description = "Configure the dock appearance.";
      type = types.submodule {

        options = {
          extendHeight = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Extends the dock to the full height of the screen (panel mode).
            '';
          };

          dockPosition = mkOption {
            type = types.str;
            default = "LEFT";
            example = "BOTTOM";
            description = ''
              Sets the position of the dock. One of "LEFT", "TOP", "RIGHT" or "BOTTOM".
            '';
          };

          applyCustomTheme = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enables the use of a custom theme for the dock.
            '';
          };

          shrinkDash = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Shrinks the dash icons to save space.
            '';
          };

          dashMaxIconSize = mkOption {
            type = types.int;
            default = 48;
            description = ''
              Sets the maximum application icon size in the dock.
            '';
          };
        };
      };
    };

    behavior = mkOption {
      description = "Configure the dock behavior.";
      type = types.submodule {
        options = {
          dockFixed = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Keeps the dock visible at all times instead of using intelligent autohide.
            '';
          };

          hotKeys = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enables using Super+{0..9} to launch applications.
            '';
          };

          disableOverviewOnStartup = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Prevents GNOME from showing overview on startup.
            '';
          };
        };
      };
    };

    show = mkOption {
      description = "Configure showing various shortcuts in the dock.";
      type = types.submodule {
        options = {
          mounts = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Show mounted drive shortcuts in the dock.
            '';
          };

          mountsNetwork = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Show mounted network drive shortcuts in the dock.
            '';
          };

          trash = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Show trash shortcut in the dock.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    dconf.settings."org/gnome/shell/extensions/dash-to-dock" = {
      extend-height = cfg.appearance.extendHeight;
      dock-fixed = cfg.behavior.dockFixed;
      dock-position = cfg.appearance.dockPosition;
      hot-keys = cfg.behavior.hotKeys;
      apply-custom-theme = cfg.appearance.applyCustomTheme;
      custom-theme-shrink = cfg.appearance.shrinkDash;
      disable-overview-on-startup = cfg.behavior.disableOverviewOnStartup;
      dash-max-icon-size = cfg.appearance.dashMaxIconSize;
      show-mounts = cfg.show.mounts;
      show-mounts-network = cfg.show.mountsNetwork;
      show-trash = cfg.show.trash;
    };

    home.packages = [ pkgs.gnomeExtensions.dash-to-dock ];
  };
}
