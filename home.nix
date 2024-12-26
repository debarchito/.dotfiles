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
  home.packages =
    (with pkgs; [
      # programs
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
      # languages
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
    ])
    ++ (with pkgs; [
      (config.lib.nixGL.wrap blender)
      (config.lib.nixGL.wrap krita)
    ]);
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
