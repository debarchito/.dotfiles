{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    environment = {
      systemPackages = with pkgs; [
        acpi
        nvme-cli
        qemu
        qemu_kvm
        virt-manager
      ];
    };
    systemd.services = {
      libvirtd = {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs.libvirt}/bin/libvirtd --listen
        '';
      };
    };
  };
}
