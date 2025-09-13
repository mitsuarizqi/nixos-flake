{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix  # Dari nixos-generate-config
  ];

  # Bootloader: GRUB untuk dual-boot (lebih reliable daripada systemd-boot)
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";  # Share ESP Windows di /boot
    };
    grub = {
      enable = true;
      device = "nodev";  # UEFI
      efiSupport = true;
      useOSProber = true;  # Auto-detect Windows
      configurationLimit = 5;  # Limit generations
    };
  };

  # File systems: Share ESP Windows (ganti /dev/sda1 dengan ESP-mu)
  fileSystems."/boot" = {
    device = "/dev/sda1";  # ESP Windows (FAT32, >=512MB)
    fsType = "vfat";
  };

  # Enable flakes permanen
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking & basic
  networking.hostName = "yuki-nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Jakarta";  # Sesuaikan
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  # Users
  users.users.youruser = {  # Ganti 'youruser'
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    initialPassword = "password";  # Ganti nanti
  };

  # Packages dasar (Yuki tambah Hyprland, ZSH, Kitty via home-manager)
  environment.systemPackages = with pkgs; [
    vim git wget curl
  ];

  # Services: SDDM untuk Hyprland login (Yuki handle detail)
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma5.enable = true;  # Opsional, untuk Hyprland

  # Home Manager integrasi (Yuki override ini)
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.youruser = import ./home.nix;  # Dari panduan sebelumnya
  };

  # State version
  system.stateVersion = "24.05";  # Sesuaikan ISO-mu
}
