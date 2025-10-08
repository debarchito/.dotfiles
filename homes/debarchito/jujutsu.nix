{
  programs = {
    jujutsu = {
      enable = true;
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
          default-command = "log";
          diff-editor = ":builtin";
        };
        git = {
          colocate = true;
          ignore-files = [ "lfs" ];
        };
      };
    };
    jjui.enable = true;
  };
}
