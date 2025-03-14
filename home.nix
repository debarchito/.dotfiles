{
  config,
  pkgs,
  thorium,
  ...
}:

{
  targets.genericLinux.enable = true;
  xdg.configFile."nixpkgs/config.nix".source = ./home/nixpkgs/config.nix;
  nixGL.packages = pkgs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidia";
  nixGL.installScripts = [
    "mesa"
    "nvidia"
  ];
  home.username = "debarchito";
  home.homeDirectory = "/home/debarchito";
  home.stateVersion = "25.05";
  home.packages = (
    with pkgs;
    [
      # programs
      chafa
      charm-freeze
      eza
      entr
      erdtree
      devenv
      distrobox
      fd
      ffmpeg
      ferium
      flatpak
      git
      gum
      glow
      gst_all_1.gstreamer
      inotify-tools
      jq
      just
      lazygit
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
      snippets-ls
      taplo
      typst
      treefmt
      typstyle
      tinymist
      umu-launcher
      vhs
      vscode-langservers-extracted
      wl-clipboard
      yaml-language-server
      zathura
      # languages
      deno
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
      (config.lib.nixGL.wrapOffload brave)
      (config.lib.nixGL.wrapOffload blender)
      (config.lib.nixGL.wrapOffload krita)
      (config.lib.nixGL.wrapOffload legcord)
      (config.lib.nixGL.wrapOffload qemu_kvm)
      (config.lib.nixGL.wrapOffload quickemu)
      (config.lib.nixGL.wrapOffload quickgui)
      (config.lib.nixGL.wrapOffload zed-editor)
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
    ./home/apps/ghostty.nix
    ./home/apps/librewolf.nix
  ];
}
