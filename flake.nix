{
  description = "NixOS with Yuki config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hapus yuki dari inputs—import lokal aja
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, home-manager, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', system, ... }: {
        # Kosong
      };
      nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          # Import Yuki lokal (sesuaikan path berdasarkan isi /tmp/yuki)
          /tmp/yuki/nixos  # Ini folder utama NixOS modules di Yuki—kalau nggak ada, ganti ke /tmp/yuki/modules/nixos atau cek ls /tmp/yuki
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
              users.youruser = import /tmp/yuki/home/youruser;  # Import home config Yuki untuk user-mu (ganti youruser, atau sesuaikan path)
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
