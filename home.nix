{
  config,
  pkgs,
  nixgl,
  ...
}:

{
  targets.genericLinux.enable = true;
  xdg.configFile."nixpkgs/config.nix".source = ./home/nixpkgs/config.nix;
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "nvidiaPrime" ];
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "25.05";
  home.packages =
    (with pkgs; [
      # programs
      bat
      btop
      eza
      erdtree
      devenv
      fd
      fzf
      flatpak
      ffmpeg
      gst_all_1.gstreamer
      helix
      just
      legcord
      mpv
      mold
      mkcert
      nil
      ripgrep
      ripgrep-all
      yazi
      zellij
      # languages
      jdk23
      # libs
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      # fonts
      julia-mono
      nerd-fonts.jetbrains-mono
      poppins
      rubik
    ])
    ++ (with pkgs; [
      (config.lib.nixGL.wrap blender)
      (config.lib.nixGL.wrap krita)
    ]);
  home.sessionVariables = rec {
    EDITOR = "hx";
    BAT_THEME = "Catppuccin Mocha";
    FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_CTRL_T_COMMAND = FZF_DEFAULT_COMMAND;
    FZF_ALT_C_COMMAND = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    FZF_CTRL_T_OPTS = "--preview 'bat --color=always -n --line-range :500 {}'";
    FZF_ALT_C_OPTS = "--preview 'eza --tree --color=always {} | head -200'";
    FZF_DEFAULT_OPTS = ''
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
      --color=selected-bg:#45475a \
      --multi
    '';
  };
  programs.home-manager.enable = true;
  imports = [
    ./home/tools/cargo.nix
    ./home/tools/direnv.nix
    ./home/tools/fish.nix
    ./home/tools/flatpak.nix
    ./home/tools/helix.nix
    ./home/tools/nushell.nix
    ./home/tools/starship.nix
    ./home/tools/zoxide.nix
    ./home/tools/zellij.nix
    ./home/apps/librewolf.nix
    ./home/apps/wezterm.nix
  ];
}
