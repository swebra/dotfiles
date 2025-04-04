{...} @ inputs: let
  # Configure inputs.nixpkgs-unstable to allow unfree
  getPkgsUnstable = arch:
    import inputs.nixpkgs-unstable {
      system = arch;
      config.allowUnfree = true;
    };
  # nixpkgs configuration (as opposed to nixpkgs-unstable) is intentionally left to the nixos and
  # home-manager modules such that legacyPackages can continue to be used for single evaluation
  # https://discourse.nixos.org/t/using-nixpkgs-legacypackages-system-vs-import/17462
in {
  makeSystem = arch: configModule:
    inputs.nixpkgs.lib.nixosSystem {
      system = arch;
      specialArgs = {
        inherit inputs;
        pkgs-unstable = getPkgsUnstable arch;
      };
      modules = [configModule ../nixos];
    };

  makeHome = arch: configModule:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${arch};
      extraSpecialArgs = {
        inherit inputs;
        pkgs-unstable = getPkgsUnstable arch;
        private = inputs.private;
      };
      modules = [configModule ../home-manager];
    };
}
