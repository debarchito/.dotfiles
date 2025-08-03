{
  programs.jujutsu = {
    enable = true;
    ediff = true;
    settings = {
      user = {
        name = "Debarchito Nath";
        email = "debarchiton@proton.me";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "A16B1370EE2B0F04";
      };
      ui.default-command = "log";
      git.ignore-files = [ "lfs" ];
    };
  };
}
