{ lib, inputs, ... }:
{
  flake-file.inputs = {
    aagl = {
      url = lib.mkDefault "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    minework = {
      url = lib.mkDefault "git+https://codeberg.org/debarchito/minework";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

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
        # Block all kinds of telemetry.
        {
          networking.hosts."0.0.0.0" = [
            "overseauspider.yuanshen.com"
            "log-upload-os.hoyoverse.com"
            "log-upload-os.mihoyo.com"
            "dump.gamesafe.qq.com"

            "apm-log-upload-os.hoyoverse.com"
            "zzz-log-upload-os.hoyoverse.com"

            "log-upload.mihoyo.com"
            "devlog-upload.mihoyo.com"
            "uspider.yuanshen.com"
            "sg-public-data-api.hoyoverse.com"
            "hkrpg-log-upload-os.hoyoverse.com"
            "public-data-api.mihoyo.com"

            "prd-lender.cdp.internal.unity3d.com"
            "thind-prd-knob.data.ie.unity3d.com"
            "thind-gke-usc.prd.data.corp.unity3d.com"
            "cdp.cloud.unity3d.com"
            "remote-config-proxy-prd.uca.cloud.unity3d.com"

            "pc.crashsight.wetest.net"
          ];
        }

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
      ];
    };

  flake.modules.homeManager.options-gaming =
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
            games = {
              minecraft.enable = lib.mkEnableOption "enable prismlauncher for Minecraft";
              genshin-impact.enable = lib.mkEnableOption "enable an-anime-game-launcher for Genshin Impact";
              honkai-star-rail.enable = lib.mkEnableOption "enable the-honkers-railway-launcher for Honkai: Star Rail";
            };
            emulators = {
              wii.enable = lib.mkEnableOption "enable emulator(s) for Wii";
              wiiu.enable = lib.mkEnableOption "enable emulator(s) for Wii U";
              switch.enable = lib.mkEnableOption "enable emulator(s) for Switch";
            };
          };
        };
        default = { };
      };

      config = lib.mkMerge [
        (lib.mkIf config.gaming.games.minecraft.enable {
          nixpkgs.overlays = [
            inputs.minework.overlays.default
          ];

          home.packages = builtins.attrValues {
            inherit (pkgs)
              prismlauncher
              minework
              ;
          };
        })

        (lib.mkIf (config.gaming.games.genshin-impact.enable || config.gaming.games.honkai-star-rail.enable)
          {
            nixpkgs.overlays = [
              inputs.aagl.overlays.default
            ];
          }
        )

        (lib.mkIf config.gaming.games.genshin-impact.enable {
          home.packages = builtins.attrValues {
            inherit (pkgs) anime-game-launcher;
          };
        })

        (lib.mkIf config.gaming.games.honkai-star-rail.enable {
          home.packages = builtins.attrValues {
            inherit (pkgs) honkers-railway-launcher;
          };
        })

        (lib.mkIf config.gaming.emulators.wii.enable {
          home.packages = builtins.attrValues {
            inherit (pkgs)
              dolphin-emu
              ;
          };
        })

        (lib.mkIf config.gaming.emulators.wiiu.enable {
          home.packages = builtins.attrValues {
            inherit (pkgs)
              cemu
              wiiudownloader
              ;
          };
        })

        (lib.mkIf config.gaming.emulators.switch.enable {
          home.packages = builtins.attrValues {
            inherit (pkgs)
              eden
              ryubing
              ;
          };
        })
      ];
    };
}
