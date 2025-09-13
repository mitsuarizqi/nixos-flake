{
  description = "NixOS basic with Yuki home";

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
              imports = [ ./yuki/home ];  # Kalau path Yuki ada; hapus kalau error
              home.username = "rizqi";
              home.homeDirectory = "/home/rizqi";
              home.stateVersion = "25.05";
            };
          };
          networking.hostName = "nixos-btw";
          time.timeZone = "Asia/Jakarta";
          networking.networkmanager.enable = true;
          system.stateVersion = "25.05";

          # Bootloader GRUB untuk UEFI + dual-boot Windows
          boot.loader = {
            efi = {
              canTouchEfiVariables = true;
              efiSysMountPoint = "/boot";  # Mount ESP di /boot
            };
            grub = {
              enable = true;
              device = "nodev";  # UEFI: Jangan ganti
              efiSupport = true;
              useOSProber = true;  # Auto-detect Windows
              configurationLimit = 5;
            };
          };

          # Mount ESP (ganti /dev/sda1 dengan ESP FAT32-mu dari lsblk)
          fileSystems."/boot" = {
            device = "/dev/sda2";
            fsType = "vfat";
          };
        }
      ];
    };
  };
}
