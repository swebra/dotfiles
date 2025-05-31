{
  description = "swebra's NixOS/home-manager configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Community zen-browser before it's in official repos
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Personal private repo
    private.url = "git+ssh://git@github.com/swebra/dotfiles-private?ref=main&shallow=1";
  };

  outputs = {...} @ inputs:
    with (import ./myLib/make-outputs.nix inputs); {
      nixosConfigurations = {
        # Temporarily build with unstable for mesa 25's 9070 XT support
        build-two = inputs.nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [./hosts/build-two/configuration.nix ./nixos];
        };
        the-cube = makeSystem "x86_64-linux" ./hosts/the-cube/configuration.nix;
        xps9575 = makeSystem "x86_64-linux" ./hosts/xps9575/configuration.nix;
        wsl = makeSystem "x86_64-linux" ./hosts/wsl/configuration.nix;
      };

      homeConfigurations = {
        default = makeHome "x86_64-linux" ./hosts/default/home.nix;
        "eric@build-two" = makeHome "x86_64-linux" ./hosts/build-two/home.nix;
        "eric@the-cube" = makeHome "x86_64-linux" ./hosts/the-cube/home.nix;
        "eric@xps9575" = makeHome "x86_64-linux" ./hosts/xps9575/home.nix;
        "eric@wsl" = makeHome "x86_64-linux" ./hosts/wsl/home.nix;
        "deck@steamdeck" = makeHome "x86_64-linux" ./hosts/steamdeck/home.nix;
      };
    };
}
