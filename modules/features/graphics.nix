{
  flake.modules.nixos.options-graphics =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
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

                hardware.nvidia =
                  let
                    kernel_6_19_patch = pkgs.fetchpatch {
                      url = "https://github.com/CachyOS/CachyOS-PKGBUILDS/raw/d5629d64ac1f9e298c503e407225b528760ffd37/nvidia/nvidia-utils/kernel-6.19.patch";
                      hash = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
                    };
                  in
                  {
                    modesetting.enable = true;
                    open = true;
                    nvidiaSettings = true;
                    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
                      version = "590.48.01";
                      sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
                      sha256_aarch64 = "sha256-FOz7f6pW1NGM2f74kbP6LbNijxKj5ZtZ08bm0aC+/YA=";
                      openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
                      settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
                      persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
                      patchesOpen = [ kernel_6_19_patch ];
                    };
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
