{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Debarchito Nath";
    userEmail = "debarchiton@proton.me";
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "git@github.com:".insteadOf = "gh:";
        "git@gitlab.com:".insteadOf = "gl:";
        "git@codeberg.org:".insteadOf = "cb:";
        "git@github.com:debarchito/".insteadOf = "me@gh:";
        "git@codeberg.org:debarchito/".insteadOf = "me@cb:";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = true;
      };
      rerere.enable = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
    };
  };
  home.packages = [
    pkgs.git-branchless
  ];
}
