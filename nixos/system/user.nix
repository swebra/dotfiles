{config, ...}: {
  users.users.${config.myOS.user} = {
    isNormalUser = true;
    description = config.myOS.user;
    extraGroups = ["networkmanager" "wheel"];
    packages = [];
  };
}
