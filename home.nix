{ config, pkgs, ... }:
{
  home.username = "raexera";
  home.homeDirectory = "/home/raexera";
  home.stateVersion = "24.05";

  programs.zsh.enable = true;
  programs.kitty.enable = true;  # Config Kitty dari yuki
  programs.vscode.enable = true;  # Extensions dari yuki
  wayland.windowManager.hyprland.enable = true;  # Hyprland config dari yuki
  # Tambah modules lain: home.packages = [ pkgs.htop ]; dll.
}
