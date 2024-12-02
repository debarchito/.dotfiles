{ pkgs, ... }:

{
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm/wezterm.lua;
}
