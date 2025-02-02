{
  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin_mocha";
    };
  };
  xdg.configFile."bat/themes/catppuccin_mocha.tmTheme".source = ./bat/catppuccin_mocha.tmTheme;
}
