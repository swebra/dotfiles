{
  config,
  lib,
  ...
} @ inputs: let
  myLib = import ../myLib inputs;
  optionNamespace = "myHome";
in {
  imports = myLib.recursiveOptionedImport [optionNamespace] ./.;

  options = {
    ${optionNamespace}.dotfilesDir = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.dotfiles";
      example = "${config.home.homeDirectory}/.dotfiles";
      description = "The (clone) location of the dotfiles repository.";
    };
  };

  config.${optionNamespace} = {
    nix.enable = true;
    shell.enable = true;
  };
}
