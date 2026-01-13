{ pkgs, ... }:

{
  programs.git.enable = true;
  programs.git.lfs.enable = true;
  programs.git.signing = {
    format = "ssh";
    signByDefault = true;
    key = "~/.ssh/id_ed25519.pub";
  };
  programs.git.settings = {
    user = {
      name = "Debarchito Nath";
      email = "debarchiton@proton.me";
    };
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
    column.ui = "auto";
    rerere.enable = true;
    diff.colorMoved = "zebra";
    branch.sort = "-committerdate";
  };

  programs.git-cliff.enable = true;

  home.packages = [
    pkgs.git-branchless
  ];
}
