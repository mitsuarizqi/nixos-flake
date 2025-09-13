{ config, pkgs, ... }:
{
  home.username = "youruser";
  home.homeDirectory = "/home/youruser";
  home.stateVersion = "24.05";
  # Yuki akan override ini dengan config-nya (Hyprland, ZSH, dll.)
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your@email.com";
  };
}
