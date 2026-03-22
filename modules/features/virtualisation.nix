{
  lib,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs.waydroid-script.url = lib.mkDefault "github:casualsnek/waydroid_script";

  flake.modules.nixos.options-virtualisation' = moduleWithSystem (
    { system, ... }:
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.virtualisation' = lib.mkOption {
        type = lib.types.submodule {
          options = {
            qemu = {
              enable = lib.mkEnableOption "enable qemu";
              runAsRoot = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "should qemu run as root?";
              };
              guest.enable = lib.mkEnableOption "enable qemu guest services";
              manager.enable = lib.mkEnableOption "enable virt-manager";
            };
            waydroid.enable = lib.mkEnableOption "enable waydroid";
          };
        };
        default = { };
      };

      config = lib.mkIf config.virtualisation'.qemu.enable (
        lib.mkMerge [
          {
            virtualisation.libvirtd = {
              enable = true;
              qemu = {
                runAsRoot = config.virtualisation'.qemu.runAsRoot;
                swtpm.enable = true;
                vhostUserPackages = [ pkgs.virtiofsd ];
              };
            };
          }

          (lib.mkIf config.virtualisation'.qemu.guest.enable {
            services = {
              qemuGuest.enable = true;
              spice-vdagentd.enable = true;
            };
          })

          (lib.mkIf config.virtualisation'.qemu.manager.enable {
            programs.virt-manager.enable = true;
          })

          (lib.mkIf config.virtualisation'.waydroid.enable {
            virtualisation.waydroid.enable = true;

            environment.systemPackages = [
              inputs.waydroid-script.packages.${system}.default
            ];
          })
        ]
      );
    }
  );
}
