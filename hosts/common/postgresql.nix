{
  services.postgresql = {
    enable = true;
    authentication = ''
      local all all trust
    '';
  };
}
