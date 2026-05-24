{ lib, inputs, ... }:
{
  flake-file.inputs.aagl = {
    url = lib.mkDefault "github:ezKEa/aagl-gtk-on-nix";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.nixos.options-gaming =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.aagl.nixosModules.default
      ];

      options.gaming = lib.mkOption {
        type = lib.types.submodule {
          options = {
            steam.enable = lib.mkEnableOption "enable steam";
            gamescope.enable = lib.mkEnableOption "enable gamescope";
            gamemode.enable = lib.mkEnableOption "enable gamemode";
            games = {
              minecraft.enable = lib.mkEnableOption "enable prismlauncher for Minecraft";
              hoyoverse.enable = lib.mkEnableOption "enable launchers for the hoyoverse games";
            };
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

          environment.systemPackages = builtins.attrValues {
            inherit (pkgs) protonplus winetricks;
          };
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

        (lib.mkIf config.gaming.games.minecraft.enable {
          environment.systemPackages = builtins.attrValues {
            inherit (pkgs)
              prismlauncher
              ;
          };
        })

        (lib.mkIf config.gaming.games.hoyoverse.enable {
          programs = {
            anime-game-launcher.enable = true;
            honkers-railway-launcher.enable = true;
          };
        })
      ];
    };
}
