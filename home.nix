{ config, pkgs, inputs, ... }:

{
  targets.genericLinux.enable = true;
  # Write to config
  xdg.configFile."nixpkgs/config.nix".source = ./home/nixpkgs/config.nix;
  # NixGL wrapper configuration
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "nvidiaPrime" ];
  # Let home-manager manage itself
  programs.home-manager.enable = true;
  # Actual home configuration
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    # Programs
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
    zellij
    # Language tools I need globally
    jdk23
    # Libs
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    # Fonts
    julia-mono
    nerd-fonts.jetbrains-mono
  ] ++ [
    # Programs that need to be wrapped
    (config.lib.nixGL.wrap pkgs.blender)
    (config.lib.nixGL.wrap pkgs.krita)
  ];
  imports = [
    ./home/tools/cargo.nix
    ./home/tools/direnv.nix
    ./home/tools/fish.nix
    ./home/tools/flatpak.nix
    ./home/tools/helix.nix
    ./home/tools/starship.nix
    ./home/tools/zoxide.nix
    ./home/tools/zellij.nix
    ./home/apps/librewolf.nix
    ./home/apps/wezterm.nix
  ];
}
