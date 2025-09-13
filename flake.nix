{
  description = "NixOS basic with Yuki later";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
      modules = [
        ./hardware-configuration.nix
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
            users.rizqi = {
              home.username = "rizqi";
              home.homeDirectory = "/home/rizqi";
              home.stateVersion = "25.05";
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
