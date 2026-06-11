{ lib, inputs, ... }:
{
  flake-file.inputs.yazi = {
    url = lib.mkDefault "github:sxyazi/yazi";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.homeManager.options-terminal =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.terminal.common.enable {
        nixpkgs.overlays = [
          inputs.yazi.overlays.default
        ];

        programs.yazi = {
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "yy";
          plugins = {
            inherit (pkgs.yaziPlugins)
              duckdb
              full-border
              git
              piper
              recycle-bin
              ;
          };
          initLua = ./yazi/init.lua;
          settings = {
            mgr.ratio = [
              0
              3
              6
            ];
            plugin = {
              prepend_previewers = [
                {
                  url = "*.md";
                  run = "piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w -s=dark \"$1\"";
                }
                {
                  url = "*.tar*";
                  run = "piper --format=url -- tar tf \"$1\"";
                }
                {
                  url = "*.csv";
                  run = "duckdb";
                }
                {
                  url = "*.tsv";
                  run = "duckdb";
                }
                {
                  url = "*.parquet";
                  run = "duckdb";
                }
                {
                  url = "*.xlsx";
                  run = "duckdb";
                }
                {
                  url = "*.duckdb";
                  run = "duckdb";
                }
                {
                  url = "*/";
                  run = "piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
                }
              ];
              prepend_fetchers = [
                {
                  group = "git";
                  url = "*";
                  run = "git";
                }
                {
                  group = "git";
                  url = "*/";
                  run = "git";
                }
              ];
              prepend_preloaders = [
                {
                  url = "*.csv";
                  run = "duckdb";
                }
                {
                  url = "*.tsv";
                  run = "duckdb";
                }
                {
                  url = "*.parquet";
                  run = "duckdb";
                }
                {
                  url = "*.xlsx";
                  run = "duckdb";
                }
                {
                  url = "*.duckdb";
                  run = "duckdb";
                }
              ];
              preview = {
                max_width = 1500;
                max_height = 1000;
              };
            };
          };
          keymap = {
            mgr.prepend_keymap = [
              {
                on = "y";
                run = [
                  "shell -- for path in %s; do echo \"file://$path\"; done | wl-copy -t text/uri-list"
                  "yank"
                ];
                desc = "Yank selection to clipboard";
              }
              {
                on = [
                  "g"
                  "t"
                ];
                run = "plugin recycle-bin";
                desc = "Manage Trash";
              }
              {
                on = [
                  "g"
                  "r"
                ];
                run = "shell -- ya emit cd \"$(git rev-parse --show-toplevel)\"";
                desc = "Go to Git root";
              }
              {
                on = [
                  "g"
                  "d"
                ];
                run = "plugin duckdb -open";
                desc = "Open with DuckDB";
              }
              {
                on = "H";
                run = "plugin duckdb -1";
                desc = "Scroll one column to the left";
              }
              {
                on = "L";
                run = "plugin duckdb +1";
                desc = "Scroll one column to the right";
              }
            ];
          };
        };

        xdg.configFile."yazi/plugins/no-header.yazi".source = ./yazi/plugins/no-header.yazi;
      };
    };
}
