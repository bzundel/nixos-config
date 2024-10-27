{ pkgs, ... }:
{
  security.polkit.enable = true;
  security.wrappers = {
    fusermount.source = "${pkgs.fuse}/bin/fusermount";
  };
}
