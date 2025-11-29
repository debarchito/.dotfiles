{ pkgs, ... }:

{
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "24.11";
  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
    pkgs.bibata-cursors
    pkgs.aseprite
    pkgs.croc
    pkgs.calibre
    pkgs.codebook
    pkgs.deno
    pkgs.duckdb
    pkgs.distrobox
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
    pkgs.blender
    pkgs.fd
    pkgs.ffmpeg
    pkgs.ferium
    pkgs.freerdp
    pkgs.fish-lsp
    pkgs.inotify-tools
    pkgs.jq
    pkgs.just
    pkgs.koji
    pkgs.krita
    pkgs.kdePackages.kconfig
    pkgs.kdePackages.karousel
    pkgs.kdePackages.kde-gtk-config
    pkgs.legcord
    pkgs.libreoffice-qt-fresh
    pkgs.minework
    pkgs.markdown-oxide
    pkgs.nvd
    pkgs.nixd
    pkgs.nix-alien
    pkgs.nix-search-tv
    pkgs.nixfmt-rfc-style
    pkgs.nix-output-monitor
    pkgs.pijul
    pkgs.podman-compose
    (pkgs.prismlauncher.override {
      jdks = [ pkgs.jdk25 ];
    })
    pkgs.qbittorrent
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.sd
    pkgs.signal-desktop
    pkgs.simple-completion-language-server
    pkgs.taplo
    pkgs.typst
    pkgs.tinymist
    pkgs.typstyle
    pkgs.unzip
    pkgs.unrar
    pkgs.vscode-langservers-extracted
    pkgs.winetricks
    pkgs.wl-clipboard
    pkgs.youtube-music
    pkgs.yaml-language-server
    pkgs.zathura
    pkgs.maple-mono.NF
    pkgs.noto-fonts-cjk-sans
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./fish.nix
    ./flatpak.nix
    ./ghostty.nix
    ./git.nix
    ./git-cliff.nix
    ./gpg.nix
    ./helix.nix
    ./jujutsu.nix
    ./kdeconnect.nix
    ./librewolf.nix
    ./mpv.nix
    ./nushell.nix
    ./obs-studio.nix
    ./starship.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
    ./zed-editor.nix
  ];

  xdg.configFile."default/cat.txt".source = ./default/cat.txt;
  home.file.".julia/config/startup.jl".source = ./julia/startup.jl;
}
