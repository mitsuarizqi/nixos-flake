{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.networkmanager.enable = true;

  # SDDM (login manager)
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # Wayland/Hyprland
  programs.hyprland.enable = true;

  # User
  users.users.yourname = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh; # optional, bisa bash kalau mau
  };

  # Packages
  environment.systemPackages = with pkgs; [
    git wget curl vim micro
    hyprland
    waybar
    alacritty
    dunst
    rofi-wayland
  ];

  # Enable sudo
  security.sudo.enable = true;

  # Timezone & locale
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
}
