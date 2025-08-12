{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.vm = {
    enable = lib.mkEnableOption "enable vm module";
    kvm.enable = lib.mkEnableOption "enable kvm";
    waydroid.enable = lib.mkEnableOption "enable waydroid";
    vmware.enable = lib.mkEnableOption "enable vmware";
  };

  config = lib.mkMerge [
    (lib.mkIf config.vm.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };
      programs.virt-manager.enable = true;
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
    })

    (lib.mkIf (config.vm.enable && config.vm.kvm.enable) {
      virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
    })

    (lib.mkIf (config.vm.enable && config.vm.waydroid.enable) {
      virtualisation.waydroid.enable = true;
    })

    (lib.mkIf (config.vm.enable && config.vm.vmware.enable) {
      virtualisation.vmware.host.enable = true;
      virtualisation.vmware.guest.enable = true;
    })
  ];
}
