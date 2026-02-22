{
  flake.modules.homeManager.options-terminal =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.terminal.common.enable {
        programs.yazi = {
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "yy";
          plugins = {
            full-border = pkgs.yaziPlugins.full-border;
            git = pkgs.yaziPlugins.git;
            no-status = pkgs.yaziPlugins.no-status;
            piper = pkgs.yaziPlugins.piper;
            duckdb = pkgs.yaziPlugins.duckdb;
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
                  run = "piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark \"$1\"";
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
                  id = "git";
                  url = "*";
                  run = "git";
                }
                {
                  id = "git";
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
                on = "H";
                run = "plugin duckdb -1";
                desc = "Scroll one column to the left";
              }
              {
                on = "L";
                run = "plugin duckdb +1";
                desc = "Scroll one column to the right";
              }
              {
                on = [
                  "g"
                  "o"
                ];
                run = "plugin duckdb -open";
                desc = "Open with DuckDB";
              }
              {
                on = [
                  "g"
                  "u"
                ];
                run = "plugin duckdb -ui";
                desc = "Open with DuckDB UI";
              }
            ];
          };
        };

        xdg.configFile."yazi/plugins/no-header.yazi".source = ./yazi/plugins/no-header.yazi;
      };
    };
}
