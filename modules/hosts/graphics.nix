{
  lib,
  pkgs,
  config,
  ...
}:

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
      hardware.nvidia-container-toolkit = {
        enable = true;
        extraArgs = [
          "--disable-hook"
          "create-symlinks"
        ];
        package = pkgs.nvidia-container-toolkit.overrideAttrs (old: {
          version = "git";
          src = pkgs.fetchFromGitHub {
            owner = "nvidia";
            repo = "nvidia-container-toolkit";
            rev = "f8daa5e26de9fd7eb79259040b6dd5a52060048c"; # v1.18.0
            hash = "sha256-6MQfZ0tDQxDQtLG1/m/qamWRL+Uv5tlQrsX8pO6UxL4=";
          };
          postPatch = ''
            substituteInPlace internal/config/config.go \
              --replace-fail '/usr/bin/nvidia-container-runtime-hook' "$tools/bin/nvidia-container-runtime-hook" \
              --replace-fail '/sbin/ldconfig' '${pkgs.glibc.bin}/sbin/ldconfig'
            # substituteInPlace tools/container/toolkit/toolkit.go \
            #   --replace-fail '/sbin/ldconfig' '${pkgs.glibc.bin}/sbin/ldconfig'
            substituteInPlace cmd/nvidia-cdi-hook/update-ldcache/update-ldcache.go \
              --replace-fail '/sbin/ldconfig' '${pkgs.glibc.bin}/sbin/ldconfig'
          '';
        });
      };
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
