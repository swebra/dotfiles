{...} @ inputs: let
  myLib = import ../myLib inputs;
in {
  imports = myLib.recursiveOptionedImport ["myHome"] ./.;

  config = {
    myHome = {
      shell.enable = true;
      meta.enable = true;
    };
  };
}
