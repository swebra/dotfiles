{...} @ inputs: let
  myLib = import ../myLib inputs;
in {
  imports = myLib.recursiveOptionedImport ["myOS"] ./.;

  config = {
    myOS = {
      nix.enable = true;
      core_programs.enable = true;
    };
  };
}
