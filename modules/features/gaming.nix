{
  flake.modules.nixos.options-gaming =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.gaming = lib.mkOption {
        type = lib.types.submodule {
          options = {
            steam.enable = lib.mkEnableOption "enable steam";
            gamescope.enable = lib.mkEnableOption "enable gamescope";
            gamemode.enable = lib.mkEnableOption "enable gamemode";
          };
        };
        default = { };
      };

      config = lib.mkMerge [
        (lib.mkIf config.gaming.steam.enable {
          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            gamescopeSession.enable = true;
            extest.enable = true;
          };

          environment.systemPackages = [
            pkgs.protonplus
          ];
        })

        (lib.mkIf config.gaming.gamescope.enable {
          programs.gamescope = {
            enable = true;
            capSysNice = true;
          };
        })

        (lib.mkIf config.gaming.gamemode.enable {
          programs.gamemode.enable = true;
        })
      ];
    };
}
