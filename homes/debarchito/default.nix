{ pkgs, ... }:

{
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "24.11";
  home.packages = [
    pkgs.aseprite
    pkgs.blender
    pkgs.bibata-cursors
    pkgs.duckdb
    pkgs.distrobox
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
    pkgs.easyeffects
    pkgs.fd
    pkgs.ffmpeg
    pkgs.ferium
    pkgs.gearlever
    pkgs.inotify-tools
    pkgs.jq
    pkgs.just
    pkgs.koji
    pkgs.krita
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.okular
    pkgs.minework
    pkgs.markdown-oxide
    pkgs.nurl
    pkgs.nix-init
    pkgs.nix-alien
    pkgs.nix-search-tv
    pkgs.nix-output-monitor
    pkgs.pijul
    pkgs.podman-compose
    pkgs.pulse-visualizer
    pkgs.qbittorrent
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.sd
    pkgs.unzip
    pkgs.unrar
    pkgs.vesktop
    pkgs.wtype
    pkgs.wl-mirror
    pkgs.wl-clipboard
    pkgs.pear-desktop
    pkgs.zathura
    pkgs.maple-mono.NF
    pkgs.noto-fonts-cjk-sans
  ];

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./atuin.nix
    ./bat.nix
    ./delta.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./flatpak.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./jujutsu.nix
    ./kdeconnect.nix
    ./librewolf.nix
    ./mpv.nix
    ./niri.nix
    ./nushell.nix
    ./obs-studio.nix
    ./rbw.nix
    ./reaper.nix
    ./starship.nix
    ./yazi.nix
    ./zed-editor.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home.file.".julia/config/startup.jl".source = ./julia/startup.jl;
}
