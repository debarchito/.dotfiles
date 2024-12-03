{ pkgs, ... }:

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
    helix
    just
    mold
    mkcert
    nil
    ripgrep
    ripgrep-all
    zellij
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
  programs.home-manager.enable = true;
  imports = [
    ./tools/cargo.nix
    ./tools/direnv.nix
    ./tools/fish.nix
    ./tools/helix.nix
    ./tools/starship.nix
    ./tools/zoxide.nix
    ./tools/zellij.nix
    ./apps/wezterm.nix
  ];
}
