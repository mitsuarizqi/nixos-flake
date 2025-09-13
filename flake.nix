{
  description = "NixOS with Yuki config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    yuki = {
      url = "github:raexera/yuki";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, yuki, home-manager, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        yuki.flakeModule
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }: {
        # Opsional: devShells.default = pkgs.mkShell { ... };
      };
      nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          yuki.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            users.users.youruser = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.youruser = import ./home.nix;
            };
            networking.hostName = "yuki-nixos";
            time.timeZone = "Asia/Jakarta";
            networking.networkmanager.enable = true;
            system.stateVersion = "24.05";
          }
        ];
      };
    };
}
