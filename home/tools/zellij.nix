{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
  };
  xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;
  xdg.configFile."zellij/themes/catppuccin.kdl".source = ./zellij/themes/catppuccin.kdl;
  xdg.configFile."zellij/themes/catppuccin.yaml".source = ./zellij/themes/catppuccin.yaml;
}
