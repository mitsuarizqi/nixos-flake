{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader: GRUB on SATA (/dev/sda)
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/sda2" ]; # install GRUB ke SATA disk
    useOSProber = true;       # deteksi OS lain
  };

  networking.hostName = "nixos-btw"; # bisa diganti sesuai mau

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";
  networking.networkmanager.enable = true;

  users.users.rizqi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ vim git firefox ];
  };

  environment.systemPackages = with pkgs; [
    wget curl htop neovim micro
  ];

  # Opsional: GUI KDE
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    xkb.layout = "us";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = true;
}
