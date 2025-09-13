{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # Modules dari yuki: ./modules/*.nix (Hyprland, ZSH, Kitty, VS Code, dll.)
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # GRUB buat dual-boot EFI
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;  # Auto-detect Windows di NVMe
    enableCryptodisk = true;  # Kalau Windows encrypted
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "yuki";
  time.timeZone = "Asia/Jakarta";

  users.users.raexera = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    # Tambah SSH keys kalau ada di yuki
  };

  environment.systemPackages = with pkgs; [ vim git ];
  # Dari yuki: programs.hyprland.enable = true; programs.zsh.enable = true; programs.vscode.enable = true; dll.

  services.xserver.enable = true;
  # Hyprland dari yuki: programs.hyprland.enable = true; services.desktopManager.plasma6.enable = false;

  system.stateVersion = "24.05";  # Sesuaikan versi NixOS
}
