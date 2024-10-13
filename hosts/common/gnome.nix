{ pkgs, ... }:
{
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ])
    ++ (with pkgs.gnome; [
      cheese
      gnome-music
      epiphany
      geary
      evince
      totem
    ]);
}
