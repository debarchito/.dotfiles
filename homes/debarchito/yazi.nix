{ lib, pkgs, ... }:

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
        preview = {
          max_width = 1500;
          max_height = 1000;
        };
      };
    };
  };
  xdg.configFile."yazi/plugins/no-header.yazi".source = ./yazi/plugins/no-header.yazi;
}
