{ lib, config, ... }:

{
  options.steam.enable = lib.mkEnableOption "enable steam module";

  config = lib.mkIf config.steam.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };
}
