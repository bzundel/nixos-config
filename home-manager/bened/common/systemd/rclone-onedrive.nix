{ pkgs, ... }:
{
  systemd.user.services.rclone-onedrive = {
    Unit = {
      Description = "Mount OneDrive to home using rclone";
    };

    Service =
      let
        onedriveDir = "/home/bened/cloud";
      in
      {
        Type = "simple";
        ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode writes onedrive:/Personal/KeePassDatabase ${onedriveDir}";
        ExecStop = "/run/wrappers/bin/fusermount -u ${onedriveDir}";
        Restart = "on-failure";
        RestartSec = "10";
      };
  };
}
