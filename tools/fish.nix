{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
      { name = "fzf.fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "foreign-env"; src = pkgs.fishPlugins.foreign-env.src; }
      { name = "transient-fish"; src = pkgs.fishPlugins.transient-fish.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages; }
    ];
    interactiveShellInit = ''
      set fish_greeting
      set -gx BAT_THEME "Catppuccin Mocha"
      set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --multi"

      zoxide init fish | source
      starship init fish | source
    '';
    shellAbbrs = {
      cd = "z";
      t = "true && clear";
      ls = "eza --long --color=always $argv";
      ll = "eza --long --color=always $argv";
      la = "eza --long --color=always $argv";
    };
  };
}
