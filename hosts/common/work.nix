{
  # TODO un-hardcode path to ovpn file
  services.openvpn.servers = {
    rz_muenster = {
      config = ''
        config /home/bened/Documents/Work/RZ_Muenster.ovpn
      '';
      autoStart = false;
      updateResolvConf = true;
    };
  };
}
