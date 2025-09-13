{
  description = "NixOS with Yuki config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Atau "nixos-24.11" untuk stable
    flake-parts.url = "github:hercules-ci/flake-parts";  # Dibutuhkan Yuki
    yuki = {
      url = "github:raexera/yuki";
      inputs.nixpkgs.follows = "nixpkgs";  # Sinkron dengan nixpkgs
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-parts, yuki, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        yuki.flakeModule
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { ... }: { };
      nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          yuki.nixosModules.default  # Import modules Yuki
          home-manager.nixosModules.home-manager
          {
            # Enable flakes permanen
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            # User setup (ganti 'youruser' dengan username-mu)
            users.users.youruser = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
              openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..." ];  # Opsional, SSH key-mu
            };
            # Home Manager integrasi
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.youruser = import ./home.nix;  # Akan kita buat nanti
            };
            # Basic system (hostname, timezone, dll. Sesuaikan)
            networking.hostName = "yuki-nixos";
            time.timeZone = "Asia/Jakarta";  # Ganti sesuai lokasi
            networking.networkmanager.enable = true;
            system.stateVersion = "24.05";  # Sesuaikan versi ISO-mu
          }
        ];
      };
    };
}
