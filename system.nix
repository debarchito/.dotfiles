{ pkgs, ... }:

{
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    environment = {
      systemPackages = with pkgs; [
        acpi
        buildah
        nvme-cli
        podman
        qemu
        qemu_kvm
        shadow
        skopeo
        virt-manager
      ];
      etc = {
        "subuid".text = ''
          debarchito:100000:65536
        '';
        "subgid".text = ''
          debarchito:100000:65536
        '';
      };
    };
    systemd.services = {
      libvirtd = {
        enable = true;
        serviceConfig = {
          Type = "simple";
        };
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs.libvirt}/bin/libvirtd
        '';
      };
    };
  };
}
