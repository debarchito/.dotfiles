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
    ./home/tools/cargo.nix
    ./home/tools/direnv.nix
    ./home/tools/fish.nix
    ./home/tools/helix.nix
    ./home/tools/starship.nix
    ./home/tools/zoxide.nix
    ./home/tools/zellij.nix
    ./home/apps/wezterm.nix
  ];
}
