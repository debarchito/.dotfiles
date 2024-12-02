{ config, pkgs, ... }:

{
  targets.genericLinux.enable = true;
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    btop
    bat
    eza
    fd
    fzf
    just
    mold
    mkcert
    nixd
    nixpkgs-fmt
    ripgrep
    ripgrep-all
    starship
    zellij
    zoxide
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
  programs.home-manager.enable = true;
  imports = [
    ./tools/fish.nix
    ./tools/helix.nix
    ./tools/cargo.nix
    ./tools/zellij.nix
    ./apps/wezterm.nix
  ];
}
