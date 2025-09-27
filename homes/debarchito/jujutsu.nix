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
        key = "5D40AFCF09EE4500";
      };
      ui = {
        paginate = "never";
        default-command = "log";
      };
      git.ignore-files = [ "lfs" ];
    };
  };
}
