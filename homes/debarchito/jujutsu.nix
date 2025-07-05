{
  programs.jujutsu = {
    enable = true;
    ediff = true;
    settings = {
      ui.default-command = "log";
      user = {
        name = "Debarchito Nath";
        email = "dev.debarchito.nath@protonmail.com";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "79647DA76CF74D66";
      };
    };
  };
}
