{...} @ inputs: {
  makeSystem = arch: configModule:
    inputs.nixpkgs.lib.nixosSystem {
      system = arch;
      specialArgs = {inherit inputs;};
      modules = [configModule ../nixos];
    };

  makeHome = arch: configModule:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${arch};
      extraSpecialArgs = {
        inherit inputs;
        private = inputs.private;
      };
      modules = [configModule ../home-manager];
    };
}
