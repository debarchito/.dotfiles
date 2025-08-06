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
        "git@github.com:".insteadOf = "gh:";
        "git@gitlab.com:".insteadOf = "gl:";
        "git@codeberg.org:".insteadOf = "cb:";
        "git@github.com:debarchito/".insteadOf = "gh:me:";
        "git@codeberg.org:debarchito/".insteadOf = "cb:me:";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = true;
      };
    };
  };
}
