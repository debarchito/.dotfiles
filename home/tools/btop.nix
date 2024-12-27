{
  programs.btop = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
    };
  };
  xdg.configFile."btop/themes/catppuccin_mocha.theme".source = ./btop/catppuccin_mocha.theme;
}
