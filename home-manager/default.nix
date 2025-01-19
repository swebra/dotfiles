{...} @ inputs: let
  myLib = import ../myLib inputs;
in {
  imports = myLib.recursiveOptionedImport ["myHome"] ./.;

  config = {
    myHome = {
      nix.enable = true;
      shell.enable = true;
    };
  };
}
