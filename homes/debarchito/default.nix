{ pkgs, ... }:

{
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "24.11";
  home.packages = [
    pkgs.aseprite
    pkgs.blender
    pkgs.bibata-cursors
    (pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
    pkgs.croc
    pkgs.codebook
    pkgs.deno
    pkgs.duckdb
    pkgs.distrobox
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
    pkgs.easyeffects
    pkgs.fd
    pkgs.ffmpeg
    pkgs.ferium
    pkgs.freerdp
    pkgs.fish-lsp
    pkgs.gearlever
    pkgs.inotify-tools
    pkgs.jq
    pkgs.just
    pkgs.koji
    pkgs.krita
    pkgs.kdePackages.kconfig
    pkgs.kdePackages.karousel
    pkgs.kdePackages.kde-gtk-config
    pkgs.libreoffice-qt-fresh
    pkgs.minework
    pkgs.markdown-oxide
    pkgs.nvd
    pkgs.nixd
    pkgs.nix-alien
    pkgs.nix-search-tv
    pkgs.nixfmt-rfc-style
    pkgs.nix-output-monitor
    pkgs.pika-backup
    pkgs.podman-compose
    pkgs.pulse-visualizer
    (pkgs.prismlauncher.override {
      jdks = [ pkgs.jdk21 ];
    })
    pkgs.qbittorrent
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.sd
    pkgs.simple-completion-language-server
    pkgs.taplo
    pkgs.typst
    pkgs.tinymist
    pkgs.typstyle
    pkgs.unzip
    pkgs.unrar
    pkgs.vesktop
    pkgs.vscode-langservers-extracted
    pkgs.winetricks
    pkgs.wl-mirror
    pkgs.wl-clipboard
    pkgs.pear-desktop
    pkgs.yaml-language-server
    pkgs.zathura
    pkgs.maple-mono.NF
    pkgs.noto-fonts-cjk-sans
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./atuin.nix
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./fish.nix
    ./flatpak.nix
    ./ghostty.nix
    ./gpg.nix
    ./helix.nix
    ./kdeconnect.nix
    ./librewolf.nix
    ./mpv.nix
    ./niri.nix
    ./nushell.nix
    ./obs-studio.nix
    ./reaper.nix
    ./starship.nix
    ./vcs.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
    ./zed-editor.nix
  ];

  home.file.".julia/config/startup.jl".source = ./julia/startup.jl;
}
