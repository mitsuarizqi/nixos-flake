{
  description = "NixOS + Hyprland + Yuki + Omarchy setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; #
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    yuki.url = "github:raexera/yuki";
  };

  outputs = { self, nixpkgs, home-manager, yuki, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          {
            # Bootloader
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # Network
            networking.networkmanager.enable = true;

            # Display Manager + Hyprland
            services.xserver.enable = true;
            services.xserver.displayManager.sddm.enable = true;
            programs.hyprland.enable = true;

            # User
            users.users.rizqi = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
              shell = pkgs.zsh; # atau bash
            };

            # Packages
            environment.systemPackages = with pkgs; [
              git wget curl vim micro
              hyprland waybar dunst rofi-wayland alacritty
            ];

            # Time + locale
            time.timeZone = "Asia/Jakarta";
            i18n.defaultLocale = "en_US.UTF-8";

            # Sudo
            security.sudo.enable = true;

            # Enable home-manager system wide
            programs.home-manager.enable = true;
          }

          # Import Yuki home-manager config
          home-manager.nixosModules.home-manager
          {
            home-manager.users.yourname = {
              imports = [ yuki.nixosModules.default ];
            };
          }
        ];
      };
    };
}
