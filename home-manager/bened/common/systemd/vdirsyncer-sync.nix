{ pkgs, ... }:
{
  home.packages = [ pkgs.vdirsyncer ];

  systemd.user.services.vdirsyncer-sync = {
    Unit = {
      Description = "Run vdirsyncer sync";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
    };
  };

  systemd.user.timers.vdirsyncer-sync = {
    Unit = {
      Description = "Timer to run vdirsyncer every half hour";
    };

    Timer = {
      OnCalendar = "*:0/30";
      Unit = "vdirsyncer-sync.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
