{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.wezterm;
  };
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;
}
