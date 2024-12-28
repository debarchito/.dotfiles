{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  xdg.configFile."yazi/theme.toml".source = ./yazi/theme.toml;
  xdg.configFile."yazi/Catppuccin-mocha.tmTheme".source = ./yazi/Catppuccin-mocha.tmTheme;
}
