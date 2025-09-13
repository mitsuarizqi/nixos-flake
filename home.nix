{ config, pkgs, ... }:

{
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  programs.git.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
}
