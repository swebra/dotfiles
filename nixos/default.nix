{lib, ...} @ inputs: let
  myLib = import ../myLib inputs;
  optionNamespace = "myOS";
in {
  imports = myLib.recursiveOptionedImport [optionNamespace] ./.;

  options.${optionNamespace} = {
    machine-name = lib.mkOption {
      description = "Hostname of the machine";
    };

    user = lib.mkOption {
      default = "eric";
      description = "Username of the main user";
    };
  };

  config.${optionNamespace} = {
    system.enable = true;
    nix.enable = true;
  };
}
