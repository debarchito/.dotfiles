{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      style = "full";
      show_help = false;
      show_tabs = false;
    };
  };
}
