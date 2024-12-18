{ pkgs, ... }:

{
  targets.genericLinux.enable = true;
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    # Programs
    bat
    btop
    eza
    devenv
    fd
    fzf
    flatpak
    helix
    just
    krita
    mpv
    mold
    mkcert
    nil
    ripgrep
    ripgrep-all
    zellij
    # Libs
    nixgl.auto.nixGLDefault
    # Fonts
    nerd-fonts.jetbrains-mono
  ];
  programs.home-manager.enable = true;
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
