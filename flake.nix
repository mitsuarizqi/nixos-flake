{
  description = "NixOS with Yuki config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nggak perlu yuki input—pakai lokal
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, home-manager, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }: {
        # Kosong
      };
      nixosConfigurations."yuki-nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          # Import Yuki host config (ganti "yuki" ke hostname di repo jika beda, misal ls /tmp/yuki/hosts/)
          /tmp/yuki/hosts/yuki
          home-manager.nixosModules.home-manager  # Backup kalau Yuki nggak include
          {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            users.users.rizqi = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.rizqi = import /tmp/yuki/hosts/yuki/home/rizqi;  # Asumsi path home user; sesuaikan kalau beda
            };
            networking.hostName = "yuki-nixos";
            time.timeZone = "Asia/Jakarta";
            networking.networkmanager.enable = true;
            system.stateVersion = "25.05";
          }
        ];
      };
    };
}
