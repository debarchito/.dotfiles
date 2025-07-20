{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Debarchito Nath";
    userEmail = "debarchiton@proton.me";
    signing = {
      key = "A16B1370EE2B0F04";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "git@github.com:debarchito/".insteadOf = "me:";
        "git@github.com:".insteadOf = "gh:";
        "git@gitlab.com:".insteadOf = "gl:";
        "git@codeberg.org:".insteadOf = "cb:";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = true;
      };
    };
  };
}
