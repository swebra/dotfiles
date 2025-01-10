{lib, ...}: {
  options = {
    opt.user = lib.mkOption {
      default = "eric";
      description = "Username of the main user";
    };
  };
}
