{
  programs.atuin.enable = true;
  programs.atuin.enableFishIntegration = true;
  programs.atuin.enableNushellIntegration = true;
  programs.atuin.flags = [
    "--disable-up-arrow"
  ];
  programs.atuin.settings = {
    style = "full";
    show_help = false;
    show_tabs = false;
  };
}
