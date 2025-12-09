{ pkgs, ... }:

{
  programs.niri.package = pkgs.niri-unstable;
  programs.dankMaterialShell = {
    enable = true;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
    };
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableBrightnessControl = true;
    enableColorPicker = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableSystemSound = true;
  };
  home.packages = [
    pkgs.xwayland-satellite
  ];
}
