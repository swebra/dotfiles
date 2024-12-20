{
  description = "swebra's Nix/NixOS/home-manager configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # Personal private repo
    private.url = "git+ssh://git@github.com/swebra/dotfiles-private?ref=main&shallow=1";
  };

  outputs = {
    nixpkgs,
    home-manager,
    private,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/wsl/configuration.nix
        ];
      };
    };
    homeConfigurations = {
      "eric@wsl" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit private;};
        modules = [./hosts/wsl/home.nix];
      };
    };
  };
}
