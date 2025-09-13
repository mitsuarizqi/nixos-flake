{
  description = "NixOS with Yuki config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hapus yuki input—import manual aja
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, home-manager, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }: {
        # Kosong
      };
      nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          # Import Yuki hosts manual (folder NixOS + Home Manager)
          ./yuki/hosts/yuki
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
              users.rizqi = {  # Config home sederhana; Yuki override via import
                home.username = "rizqi";
                home.homeDirectory = "/home/rizqi";
                home.stateVersion = "25.05";
                # Tambah Yuki home modules manual kalau perlu (misal programs.hyprland.enable = true;)
              };
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
