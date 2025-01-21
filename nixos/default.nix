{...} @ inputs: let
  myLib = import ../myLib inputs;
in {
  imports = myLib.recursiveOptionedImport ["myOS"] ./.;

  config = {
    myOS = {
      nix.enable = true;
    };
  };
}
