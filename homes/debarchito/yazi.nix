{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
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
            name = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark \"$1\"";
          }
          {
            name = "*.tar*";
            run = "piper --format=url -- tar tf \"$1\"";
          }
          {
            name = "*.csv";
            run = "duckdb";
          }
          {
            name = "*.tsv";
            run = "duckdb";
          }
          {
            name = "*.parquet";
            run = "duckdb";
          }
          {
            name = "*.xlsx";
            run = "duckdb";
          }
          {
            name = "*.duckdb";
            run = "duckdb";
          }
          {
            name = "*/";
            run = "piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
        prepend_preloaders = [
          {
            name = "*.csv";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.tsv";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.parquet";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.xlsx";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.duckdb";
            run = "duckdb";
            multi = false;
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
}
