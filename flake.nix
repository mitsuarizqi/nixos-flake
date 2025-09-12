{
  description = "NixOS config with Hyprland, Yuki, Omarchy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    yuki.url = "github:raexera/yuki";
    omarchy.url = "github:ChrisTitusTech/omarchy-titus";
  };

  outputs = { self, nixpkgs, home-manager, yuki, omarchy, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rizqi = {
              imports = [
                yuki.homeManagerModules.default
                omarchy.homeManagerModules.default
              ];
            };
          }
        ];
      };
    };
}
