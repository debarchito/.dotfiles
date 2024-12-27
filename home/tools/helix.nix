{
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
  xdg.configFile."helix/config.toml".source = ./helix/config.toml;
  xdg.configFile."helix/languages.toml".source = ./helix/languages.toml;
}
