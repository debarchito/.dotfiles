{ config, pkgs, ... }:

{
  programs.rio = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.rio;
  };
  xdg.configFile."rio/config.toml".source = ./rio/config.toml;
}
