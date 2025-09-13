{
  description = "NixOS with Yuki config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yuki = {
      url = "path:./yuki";  # Import lokal dari /etc/nixos/yuki
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, home-manager, yuki, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }: {
        # Kosong
      };
      nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          yuki.nixosModules.default  # Asumsi Yuki expose ini; kalau error, coba yuki.outputs.nixosModules.default atau /tmp/yuki/hosts/yuki
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
              users.rizqi = import ./yuki/hosts/yuki/home/rizqi;  # Sesuaikan path home kalau beda (misal default.nix)
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
