{ lib, pkgs, ... }:
let
  rich.run = "piper -- ${pkgs.rich-cli}/bin/rich -j --left --panel=rounded --guides --line-numbers --force-terminal \"$1\"";
in
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
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
      plugin.prepend_previewers = [
        (
          {
            name = "*.md";
          }
          // rich
        )
        (
          {
            name = "*.csv";
          }
          // rich
        )
        (
          {
            name = "*.rst";
          }
          // rich
        )
        (
          {
            name = "*.ipynb";
          }
          // rich
        )
        (
          {
            name = "*.json";
          }
          // rich
        )
        {
          name = "*.tar*";
          run = "piper --format=url -- tar tf \"$1\"";
        }
        {
          name = "*/";
          run = "piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
        }
      ];
      preview = {
        max_width = 1500;
        max_height = 1000;
      };
    };
  };
  xdg.configFile."yazi/theme.toml".source = lib.mkForce ./yazi/theme.toml;
  xdg.configFile."yazi/Catppuccin-mocha.tmTheme".source = lib.mkForce ./yazi/Catppuccin-mocha.tmTheme;
  xdg.configFile."yazi/plugins/no-header.yazi".source = ./yazi/plugins/no-header.yazi;
}
