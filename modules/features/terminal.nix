{
  flake.modules.homeManager.options-terminal =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.terminal = lib.mkOption {
        type = lib.types.submodule {
          options = {
            common.enable = lib.mkEnableOption "terminal-based tools that i need everywhere";
          };
        };
        default = { };
      };

      config = lib.mkIf config.terminal.common.enable {
        programs = {
          atuin = {
            enable = true;
            enableFishIntegration = true;
            flags = [
              "--disable-up-arrow"
            ];
            settings = {
              style = "full";
              show_help = false;
              show_tabs = false;
            };
          };

          bat.enable = true;

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

          direnv = {
            enable = true;
            nix-direnv.enable = true;
            config.global.hide_env_diff = true;
          };

          eza = {
            enable = true;
            enableFishIntegration = true;
          };

          fd.enable = true;

          fzf = {
            enable = true;
            defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
            changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
            changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -200'" ];
            fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
            fileWidgetOptions = [ "--preview 'bat --color=always -n --line-range :500 {}'" ];
          };

          git = {
            enable = true;
            lfs.enable = true;
            settings = {
              init.defaultBranch = "main";
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

          git-cliff.enable = true;

          gpg.enable = true;

          jujutsu = {
            enable = true;
            settings = {
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
          };

          jjui.enable = true;

          jq.enable = true;

          ripgrep.enable = true;

          ripgrep-all.enable = true;

          zellij.enable = true;

          zoxide = {
            enable = true;
            enableFishIntegration = true;
          };
        };

        services.gpg-agent = {
          enable = true;
          enableFishIntegration = true;
          enableSshSupport = true;
          pinentry.package = pkgs.pinentry-qt;
        };

        xdg.configFile =
          let
            vars = {
              USERNAME = config.home.username;
            };
          in
          {
            "zellij/config.kdl".source = pkgs.replaceVars ./terminal/zellij/config.kdl vars;
          };

        home.packages = [
          pkgs.git-branchless
          pkgs.koji
          pkgs.sd
        ];
      };
    };
}
