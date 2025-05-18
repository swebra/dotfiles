{lib, ...}: {
  options = {
    myOS.user = lib.mkOption {
      default = "eric";
      description = "Username of the main user";
    };
  };
}
