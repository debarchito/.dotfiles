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
  home.packages = (
    with pkgs;
    [
      # programs
      charm-freeze
      eza
      entr
      erdtree
      devenv
      fd
      ffmpeg
      ferium
      flatpak
      git
      gum
      glow
      gst_all_1.gstreamer
      jq
      just
      legcord
      mold
      mkcert
      marksman
      nb
      nixd
      nixfmt-rfc-style
      nix-output-monitor
      ripgrep
      rainfrog
      ripgrep-all
      slides
      taplo
      typst
      typstyle
      tinymist
      vhs
      vscode-langservers-extracted
      yaml-language-server
      zathura
      # languages
      deno
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
      # programs that need wrapping
      (config.lib.nixGL.wrap blender)
      (config.lib.nixGL.wrap krita)
      (config.lib.nixGL.wrap zed-editor)
    ]
  );
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  imports = [
    ./home/tools/bat.nix
    ./home/tools/btop.nix
    ./home/tools/cargo.nix
    ./home/tools/carapace.nix
    ./home/tools/direnv.nix
    ./home/tools/fzf.nix
    ./home/tools/fish.nix
    ./home/tools/flatpak.nix
    ./home/tools/helix.nix
    ./home/tools/mpv.nix
    ./home/tools/nushell.nix
    ./home/tools/starship.nix
    ./home/tools/yazi.nix
    ./home/tools/zoxide.nix
    ./home/tools/zellij.nix
    ./home/apps/librewolf.nix
    ./home/apps/wezterm.nix
  ];
}
