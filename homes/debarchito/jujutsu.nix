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
          backend = "ssh";
          key = "~/.ssh/id_ed25519.pub";
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
