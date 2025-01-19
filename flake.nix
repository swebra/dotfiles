{
  description = "swebra's NixOS/home-manager configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # Community zen-browser before it's in official repos
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Personal private repo
    private.url = "git+ssh://git@github.com/swebra/dotfiles-private?ref=main&shallow=1";
  };

  outputs = {...} @ inputs:
    with (import ./myLib/make-outputs.nix inputs); {
      nixosConfigurations = {
        xps9575 = makeSystem "x86_64-linux" ./hosts/xps9575/configuration.nix;
        wsl = makeSystem "x86_64-linux" ./hosts/wsl/configuration.nix;
      };

      homeConfigurations = {
        "eric@xps9575" = makeHome "x86_64-linux" ./hosts/xps9575/home.nix;
        "eric@wsl" = makeHome "x86_64-linux" ./hosts/wsl/home.nix;
      };
    };
}
