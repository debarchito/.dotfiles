{
  programs.ghostty = {
    enable = true;
    settings = {
      command = "fish";
      shell-integration = "fish";
      window-decoration = "none";
      window-padding-x = 10;
      window-padding-y = "0,0";
      font-family = "Maple Mono NF";
      font-size = 14;
      font-feature = "-calt, -liga, -dlig";
      config-file = "./themes/dankcolors";
      app-notifications = "no-clipboard-copy,no-config-reload";
    };
  };
}
