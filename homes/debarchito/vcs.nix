{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      signing = {
        format = "ssh";
        signByDefault = true;
        key = "~/.ssh/id_ed25519.pub";
      };
      settings = {
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
    };

    jujutsu = {
      enable = true;
      settings = {
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
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        true-color = "always";
        merge.conflictStyle = "zdiff3";
      };
    };

    git-cliff.enable = true;
    jjui.enable = true;
  };

  home.packages = [
    pkgs.git-branchless
    pkgs.pijul
  ];
}
