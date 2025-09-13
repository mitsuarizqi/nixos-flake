{
  description = "Yuki NixOS Config - Snowflake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Tambah dari yuki kalau ada (misal hyprland.url = "github:hyprwm/Hyprland"; dll.)
    flake-parts.url = "github:hercules-ci/flake-parts";  # Kalau yuki pake ini
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs { inherit system; };
      };
      flake = {
        nixosConfigurations.yuki = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.raexera = import ./home.nix;  # User dari yuki
            }
            # Import modules yuki: ./modules/hyprland.nix ./modules/zsh.nix dll.
          ];
        };
      };
    };
}
