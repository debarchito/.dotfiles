{
  flake.modules.nixos.options-common =
    { lib, config, ... }:
    {
      options.common = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "common settings that can be shared between multiple hosts";
            desktop.enable = lib.mkEnableOption "desktop specific common settings";
            flake = lib.mkOption {
              type = lib.types.str;
              default = "/etc/nixos";
              description = "path to the flake to use";
            };
            gc.arguments = lib.mkOption {
              type = lib.types.str;
              default = "--delete-older-than 7d --keep 2";
              description = "additional options for garbage collection";
            };
          };
        };
        default = { };
      };

      config = lib.mkIf config.common.enable (
        lib.mkMerge [
          {
            services.fail2ban.enable = true;

            nix.settings = {
              experimental-features = [
                "nix-command"
                "flakes"
                "pipe-operators"
              ];
              auto-optimise-store = true;
            };

            programs = {
              nix-ld.enable = true;
              nh = {
                enable = true;
                inherit (config.common) flake;
                clean = {
                  enable = true;
                  extraArgs = config.common.gc.arguments;
                };
              };
            };
          }

          (lib.mkIf config.common.desktop.enable {
            security = {
              polkit.enable = true;
              rtkit.enable = true;
            };

            services = {
              colord.enable = true;
              fwupd.enable = true;
              printing.enable = true;
              upower.enable = true;
              power-profiles-daemon.enable = true;
            };
          })
        ]
      );
    };
}
