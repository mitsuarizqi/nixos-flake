{
  description = "Yuki NixOS Config - Snowflake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Tambah inputs yuki lain kalau ada (hyprland, dll.)
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, ... }@inputs:
    let
      system = "x86_64-linux";  # Ganti kalau ARM
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;  # Ini override global buat semua!
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ system ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = pkgs;  # Pass pkgs custom ke modules
      };
      flake = {
        nixosConfigurations.yuki = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs pkgs; };  # Pass pkgs ke specialArgs
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;  # Penting: HM pake pkgs dari system
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit pkgs; };  # Pass ke HM users
              home-manager.users.raexera = import ./home.nix;
            }
            # ... modules yuki lain
          ];
        };
      };
    };
}
