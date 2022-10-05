{
  description = "NixOS configuration with two or more channels";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-22_05.url = "nixpkgs/nixos-22.05";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-22_05,
    neovim-nightly-overlay,
    home-manager,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) nixosSystem;

    system = "x86_64-linux";
    overlay-22_05 = final: prev: {
      stable-22_05 = import nixpkgs-22_05 {
        inherit system;
        config.allowUnfree = true;
      };
    };

    customoverlay = final: prev: {
    };

    overlays = [
      overlay-22_05
      neovim-nightly-overlay.overlay
      customoverlay
    ];
  in {
    nixosConfigurations."xps15" = nixosSystem {
      inherit system;
      modules = [
        # Overlays-module makes "pkgs.stable-22_05" available in configuration.nix
        ({
          config,
          pkgs,
          ...
        }: {nixpkgs.overlays = overlays;})
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.enric = import ./enric.nix;
          home-manager.extraSpecialArgs = {};
        }
      ];
    };
  };
}
