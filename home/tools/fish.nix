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
    interactiveShellInit = ''
      set fish_greeting
      set -Ux BAT_THEME "Catppuccin Mocha"
      set -Ux FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
      set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
      set -Ux FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
      set -Ux FZF_CTRL_T_OPTS "--preview 'bat --color=always -n --line-range :500 {}'"
      set -Ux FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"
      set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --multi"
    '';
    shellAbbrs = {
      cd = "z";
      t = "true && clear";
      ls = "eza --long --color=always";
      ll = "eza --long --color=always";
      la = "eza --long --color=always";
    };
  };
}
