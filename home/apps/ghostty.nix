{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
  };
  xdg.configFile."ghostty/config".source = ./ghostty/config;
}
