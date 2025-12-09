{ pkgs, ... }:

{
  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-wlr
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

}
