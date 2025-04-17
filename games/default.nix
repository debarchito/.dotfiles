{
  imports = [
    ./aagl.nix
  ];

  # Some stuff I suppose.
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode.enable = true;

  # Steam stuff.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Controller stuff.
  hardware.xone.enable = true;
}
