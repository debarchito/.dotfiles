{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pisces";
        src = pkgs.fishPlugins.pisces.src;
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "transient-fish";
        src = pkgs.fishPlugins.transient-fish.src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
    ];
    loginShellInit = ''
      fish_config theme save "Catppuccin Mocha"
    '';
    interactiveShellInit = ''
      set fish_greeting
    '';
    preferAbbrs = true;
    shellAbbrs = {
      cd = "z";
      tree = "erd";
      t = "true && clear";
      ls = "eza --long --color=always";
      ll = "eza --long --color=always -l";
      la = "eza --long --color=always -a";
    };
  };
  xdg.configFile."fish/themes/Catppuccin_Mocha.theme".source = ./fish/Catppuccin_Mocha.theme;
}
