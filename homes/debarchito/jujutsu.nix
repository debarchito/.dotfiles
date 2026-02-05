{
  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    user = {
      name = "Debarchito Nath";
      email = "debarchiton@proton.me";
    };
    signing = {
      backend = "ssh";
      behavior = "own";
      key = "~/.ssh/id_ed25519.pub";
    };
    ui = {
      default-command = "log";
      conflict-marker-style = "snapshot";
      diff-editor = ":builtin";
    };
    git = {
      colocate = true;
      ignore-files = [ "lfs" ];
    };
    remotes = {
      origin.auto-track-bookmarks = "glob:*";
      upstream.auto-track-bookmarks = "main";
    };
  };

  programs.jjui.enable = true;
}
