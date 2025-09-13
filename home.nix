{ config, pkgs, ... }:

{
  home.username = "rizqi";
  home.homeDirectory = "/home/rizqi";
  programs.git.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
}
