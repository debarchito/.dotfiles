{
  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    command = "fish";
    shell-integration = "fish";
    window-decoration = "none";
    window-padding-x = 10;
    window-padding-y = "0,0";
    font-family = "Maple Mono NF";
    font-size = 14;
    font-feature = "-calt,-zero,-cv02,+cv01,+cv61";
    config-file = "./themes/dankcolors";
    app-notifications = "no-clipboard-copy,no-config-reload";
  };
}
