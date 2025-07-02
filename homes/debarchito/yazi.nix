{ lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
      no-status = pkgs.yaziPlugins.no-status;
    };
    initLua = ./yazi/init.lua;
    settings = {
      mgr.ratio = [
        2
        2
        5
      ];
    };
  };
  xdg.configFile."yazi/theme.toml".source = lib.mkForce ./yazi/theme.toml;
  xdg.configFile."yazi/Catppuccin-mocha.tmTheme".source = lib.mkForce ./yazi/Catppuccin-mocha.tmTheme;
  xdg.configFile."yazi/plugins/no-header.yazi".source = ./yazi/plugins/no-header.yazi;
}
