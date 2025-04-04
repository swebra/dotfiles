{...} @ inputs: let
  myLib = import ../myLib inputs;
  optionNamespace = "myOS";
in {
  imports = myLib.recursiveOptionedImport [optionNamespace] ./.;

  config.${optionNamespace} = {
    nix.enable = true;
  };
}
