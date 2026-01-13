{ pkgs, ... }:

{
  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = [
    pkgs.obs-studio-plugins.obs-pipewire-audio-capture
    pkgs.obs-studio-plugins.obs-vkcapture
  ];
}
