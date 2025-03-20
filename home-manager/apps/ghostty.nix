{ config, pkgs, ... }:

{
  programs.ghostty.enable = true;
  xdg.configFile."ghostty/config".source = ./ghostty/config;
}
