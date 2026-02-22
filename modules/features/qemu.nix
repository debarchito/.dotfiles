{
  flake.modules.nixos.options-qemu =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options = {
        qemu.enable = lib.mkEnableOption "enable qemu";
        qemu.runAsRoot = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "should qemu run as root?";
        };
        qemu.guest.enable = lib.mkEnableOption "enable qemu guest services";
        qemu.manager.enable = lib.mkEnableOption "enable virt-manager";
      };

      config = lib.mkIf config.qemu.enable (
        lib.mkMerge [
          {
            virtualisation.libvirtd.enable = true;
            virtualisation.libvirtd.qemu.runAsRoot = config.qemu.runAsRoot;
            virtualisation.libvirtd.qemu.swtpm.enable = true;
            virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
          }

          (lib.mkIf config.qemu.guest.enable {
            services.qemuGuest.enable = true;
            services.spice-vdagentd.enable = true;
          })

          (lib.mkIf config.qemu.manager.enable {
            programs.virt-manager.enable = true;
          })
        ]
      );
    };
}
