{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
  };
  xdg.configFile."zellij/themes".source = ./zellij/themes;
  xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;
}
