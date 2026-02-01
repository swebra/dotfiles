{config, ...}: {
  networking = {
    networkmanager.enable = true;
    hostName = config.myOS.machine-name;
  };
}
