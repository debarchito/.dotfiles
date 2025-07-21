{
  programs.jujutsu = {
    enable = true;
    ediff = true;
    settings = {
      ui.default-command = "log";
      user = {
        name = "Debarchito Nath";
        email = "debarchiton@proton.me";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "A16B1370EE2B0F04";
      };
    };
  };
}
