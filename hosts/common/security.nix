{ pkgs, ... }:
{
  security.wrappers = {
    fusermount.source = "${pkgs.fuse}/bin/fusermount";
  };
}
