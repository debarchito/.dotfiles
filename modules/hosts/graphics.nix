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
        # package = config.boot.kernelPackages.nvidiaPackages.latest;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "575.64.05";
          sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
          sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
          openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
          settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
          persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
        };
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
