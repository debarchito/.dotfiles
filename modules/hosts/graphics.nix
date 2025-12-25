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
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (lib.mkIf (config.graphics.enable && config.graphics.nvidia.enable) {
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        # package = config.boot.kernelPackages.nvidiaPackages.latest;
        # R590 is broken for me
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "580.119.02";
          sha256_64bit = "sha256-gCD139PuiK7no4mQ0MPSr+VHUemhcLqerdfqZwE47Nc=";
          sha256_aarch64 = "sha256-eYcYVD5XaNbp4kPue8fa/zUgrt2vHdjn6DQMYDl0uQs=";
          openSha256 = "sha256-l3IQDoopOt0n0+Ig+Ee3AOcFCGJXhbH1Q1nh1TEAHTE=";
          settingsSha256 = "sha256-sI/ly6gNaUw0QZFWWkMbrkSstzf0hvcdSaogTUoTecI=";
          persistencedSha256 = "sha256-j74m3tAYON/q8WLU9Xioo3CkOSXfo1CwGmDx/ot0uUo=";
        };
      };
      hardware.nvidia-container-toolkit.enable = true;
      environment.systemPackages = [
        config.hardware.nvidia-container-toolkit.package
      ];
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
