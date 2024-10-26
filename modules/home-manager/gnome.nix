{ config, pkgs, ... }:
with lib;
let
  cfg = config.gnome;
in
{
  options.gnome = {
    enable = mkEnableOption "GNOME appearance customization";

    appearance = mkOption {
      description = "Manage appearance settings for GNOME";
      type = types.submodule {

        lightMode = mkOption {
          # org/gnome/desktop/interface/color-scheme ("prefer-dark" or "prefer-light")
          type = types.bool;
          default = true;
          description = ''
            Use light mode (true) or dark mode (false).
          '';
        };

        showBatteryPercentage = mkOption {
          # org/gnome/desktop/interface/show-battery-percentage
          type = types.bool;
          default = false;
          description = ''
            Show battery percentage next to icon.
          '';
        };

        titlebarButtons = mkOption {
          # org/gnome/desktop/wm/preferences/button-layout (use optionalString to create setting dynamically)
          description = "Configure GNOME titlebar buttons.";
          type = types.submodule {

            options = {
              minimize = mkOption {
                type = types.bool;
                default = false;
                description = "Show the minimize button in a window's title bar.";
              };

              maximize = mkOption {
                type = types.bool;
                default = false;
                description = "Show the minimize button in a window's title bar.";
              };
            };
          };
        };
      };
    };

    multitasking = mkOption {
      description = "Manage multitasking settings for GNOME";
      type = types.submodule {

        options = {
          hotCorner = mkOption {
            # org/gnome/desktop/interface/enable-hot-corners
            type = types.bool;
            default = true;
            description = "Enables hot corner to open activities overview.";
          };

          activeScreenEdges = mkOptions {
            # org/gnome/mutter/edge-tiling
            type = types.bool;
            default = false;
            description = "Enables active screen edges to resize windows when dragged against.";
          };

          workspaces = mkOption {
            description = "Manage workspace settings for GNOME";
            type = types.submodule {

              options = {
                dynamicWorkspaces = mkOption {
                  # org/gnome/mutter/dynamic-workspaces
                  type = types.bool;
                  default = true;
                  description = "Use dynamic workspaces.";
                };

                numberOfWorkspaces = mkOption {
                  # org/gnome/desktop/wm/preferences/num-workspaces
                  type = types.ints.positive;
                  default = 4;
                  description = "Number of fixed workspaces. Value must be an integer within the inclusive range of 1 to 36. Only affects workspace count when using fixed number of workspaces (i.e. dynamic workspaces are off).";
                  apply =
                    val:
                    assert val >= 1 && val <= 36;
                    val;
                };

                workspacesOnlyOnPrimary = mkOption {
                  # org/gnome/mutter/workspaces-only-on-primary
                  type = types.bool;
                  default = false;
                  description = "Switched workspaces only on the primary display.";
                };
              };
            };
          };
        };
      };
    };

    power = mkOption {
      description = "Manage power settings for GNOME";
      type = types.submodule {

        options = {
          dimScreen = mkOption {
            # org/gnome/settings-daemon/plugins/power/idle-dim

          };

          screenBlank = mkOption {
            # org/gnome/desktop/session/idle-delay
            type = types.ints.u32;
            default = 300;
            description = "Time until screen blank (in seconds). Value 0 disables screen blank entierely.";
          };

          automaticSuspend = mkOption {
            description = "Manage automatic suspend options in GNOME.";
            type = types.submodule {

              options = {
                battery = mkOption {
                  description = "Manage automatic suspend options when on battery power.";
                  type = types.submodule {

                    options = {
                      enable = mkOption {
                        # org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type ('suspend' when true, 'nothing' if false)
                        type = types.bool;
                        default = true;
                        description = "Enable automatic suspend when on battery power.";
                      };

                      delay = mkOption {
                        # org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout
                        type = types.int;
                        default = 900;
                        description = "Inactivity delay (in seconds) to suspend when on battery power. Value must be larger or equal than 900. Has an effect only when automatic suspend is enabled.";
                        apply =
                          val:
                          assert val >= 900;
                          val;
                      };
                    };
                  };
                };

                ac = mkOption {
                  description = "Manage automatic suspend options when plugged in.";
                  type = types.submodule {

                    options = {
                      enable = mkOption {
                        # org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type ('suspend' when true, 'nothing' if false)
                        type = types.bool;
                        default = true;
                        description = "Enable automatic suspend when plugged in.";
                      };

                      delay = mkOption {
                        # org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout
                        type = types.int;
                        default = 900;
                        description = "Inactivity delay (in seconds) to suspend when plugged in. Value must be larger or equal than 900. Has an effect only when automatic suspend is enabled.";
                        apply =
                          val:
                          assert val >= 900;
                          val;
                      };
                    };
                  };
                };
              };
            };
          };

          # TODO continue here
        };
      };
    };
  };

  config = mkIf cfg.enable { };
}
