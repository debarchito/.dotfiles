{ lib, config, ... }:

{
  options.graphics = {
    enable = lib.mkEnableOption "enable graphics module";
    nvidia = {
      enable = lib.mkEnableOption "enable nvidia support";
      prime = {
        enable = lib.mkEnableOption "enable nvidia prime support";
        offload.enable = lib.mkEnableOption "enable nvidia prime offload";
        intelBusId = lib.mkOption {
          description = "the intel pci bus id";
        };
        nvidiaBusId = lib.mkOption {
          description = "the nvidia pci bus id";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.graphics.enable {
      hardware.graphics.enable = true;
    })

    (lib.mkIf (config.graphics.enable && config.graphics.nvidia.enable) {
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
      hardware.nvidia-container-toolkit.enable = true;
    })

    (lib.mkIf
      (config.graphics.enable && config.graphics.nvidia.enable && config.graphics.nvidia.prime.enable)
      {
        hardware.nvidia.prime = {
          intelBusId = config.graphics.nvidia.prime.intelBusId;
          nvidiaBusId = config.graphics.nvidia.prime.nvidiaBusId;
        };
      }
    )

    (lib.mkIf
      (
        config.graphics.enable
        && config.graphics.nvidia.enable
        && config.graphics.nvidia.prime.enable
        && config.graphics.nvidia.prime.offload.enable
      )
      {
        hardware.nvidia.prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
        };
      }
    )
  ];
}
