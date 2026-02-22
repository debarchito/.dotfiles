{
  flake.modules.nixos.options-graphics =
    { lib, config, ... }:
    {
      options = {
      };

      options.graphics = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "enable graphics module";
            nvidia = {
              enable = lib.mkEnableOption "enable nvidia support";
              prime = {
                enable = lib.mkEnableOption "enable nvidia prime support";
                settings = lib.mkOption {
                  type = lib.types.attrs;
                  default = { };
                  description = "raw attribute set passed directly to hardware.nvidia.prime";
                };
              };
            };
          };
        };
        default = { };
      };

      config = lib.mkIf config.graphics.enable (
        lib.mkMerge [
          {
            hardware.graphics = {
              enable = true;
              enable32Bit = true;
            };
          }

          (lib.mkIf config.graphics.nvidia.enable (
            lib.mkMerge [
              {
                services.xserver.videoDrivers = [ "nvidia" ];

                hardware.nvidia = {
                  modesetting.enable = true;
                  open = true;
                  nvidiaSettings = true;
                  package = config.boot.kernelPackages.nvidiaPackages.latest;
                };
              }

              (lib.mkIf config.containers'.enable {
                hardware.nvidia-container-toolkit.enable = true;

                environment.systemPackages = [
                  config.hardware.nvidia-container-toolkit.package
                ];
              })

              (lib.mkIf config.graphics.nvidia.prime.enable {
                hardware.nvidia.prime = config.graphics.nvidia.prime.settings;
              })
            ]
          ))
        ]
      );
    };
}
