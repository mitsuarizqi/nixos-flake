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
      # Hapus yuki.flakeModule dari sini—ganti di modules NixOS
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }: {
        # Kosong atau devShell jika perlu
      };
      nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          # Import Yuki modules manual (coba default; kalau error, ganti ke yuki.nixosModule.homeConfigurations atau cek repo)
          inputs.yuki.nixosModules.default  # Atau yuki.nixosModules.home-manager jika beda
          home-manager.nixosModules.home-manager
          {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            users.users.rizqi = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.youruser = import ./home.nix;
            };
            networking.hostName = "nixos-btw";
            time.timeZone = "Asia/Jakarta";
            networking.networkmanager.enable = true;
            system.stateVersion = "25.05";
          }
        ];
      };
    };
}
