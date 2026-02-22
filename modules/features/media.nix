{
  inputs,
  moduleWithSystem,
  lib,
  ...
}:
{
  flake-file.inputs = {
    musnix.url = lib.mkDefault "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    nixpkgs-yabridge.url = lib.mkDefault "github:nixos/nixpkgs/7d1e6f1288a41e5fdbd4c5c82d495b51d49511a4";
  };

  flake.modules.nixos.options-media =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.musnix.nixosModules.musnix
      ];

      options.media = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "enable the media stack";
            bluetooth.enable = lib.mkEnableOption "enable the bluetooth stack";
            routing.enable = lib.mkEnableOption "add tools that aid in media routing";
            optimizations.enable = lib.mkEnableOption "enable useful optimizations for realtime and low latency work";
            streaming = {
              client.enable = lib.mkEnableOption "enable moonlight";
              server = {
                enable = lib.mkEnableOption "enable sunshine for streaming";
                autostart = lib.mkEnableOption "enable sunshine server automatically";
              };
            };
          };
        };
        default = { };
      };

      config = lib.mkIf config.media.enable (
        lib.mkMerge [
          {
            services.pipewire = {
              enable = true;
              alsa.enable = true;
              pulse.enable = true;
              jack.enable = true;
              wireplumber.enable = true;
            };
          }

          (lib.mkIf config.media.bluetooth.enable {
            hardware.bluetooth.enable = true;
          })

          (lib.mkIf config.media.routing.enable {
            environment.systemPackages = [
              pkgs.qpwgraph
            ];
          })

          (lib.mkIf config.media.optimizations.enable {
            musnix.enable = true;

            services.pipewire.extraConfig.jack = {
              "10-clock-rate" = {
                "jack.properties" = {
                  "node.latency" = "128/48000";
                  "node.rate" = "1/48000";
                  "node.lock-quantum" = true;
                };
              };
            };
          })

          (lib.mkIf config.media.streaming.server.enable {
            services.sunshine = {
              enable = true;
              autoStart = config.media.streaming.server.autostart;
              capSysAdmin = true;
              openFirewall = true;
            };
          })

          (lib.mkIf config.media.streaming.client.enable {
            environment.systemPackages = [
              pkgs.moonlight-qt
            ];
          })
        ]
      );
    };

  flake.modules.homeManager.options-media = moduleWithSystem (
    { self', system, ... }:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.media = lib.mkOption {
        type = lib.types.submodule {
          options = {
            daw.enable = lib.mkEnableOption "enable my digital audio workstation stack";
          };
        };
        default = { };
      };

      config =
        let
          pkgs-yabridge = import inputs.nixpkgs-yabridge { inherit system; };
        in
        lib.mkIf config.media.daw.enable {
          home.packages = [
            self'.packages.reaper
            pkgs-yabridge.yabridge
            pkgs-yabridge.yabridgectl
          ];

          xdg.configFile."REAPER/UserPlugins/reaper_reapack-x86_64.so".source =
            "${pkgs.reaper-reapack-extension}/UserPlugins/reaper_reapack-x86_64.so";
          xdg.configFile."REAPER/UserPlugins/reaper_sws-x86_64.so".source =
            "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-x86_64.so";

          home.file.".vst3/Stochas.vst3".source = "${pkgs.stochas}/lib/vst3/Stochas.vst3";
        };
    }
  );
}
