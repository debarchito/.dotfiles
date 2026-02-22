let
  name = "dell-laptop";
in
{
  flake.modules.nixos."hosts-${name}" =
    { pkgs, ... }:
    {
      # NOTE: Generated files are treated as external dependencies thus are a special case for relative imports.
      imports = [
        ./_generated/hardware-configuration.nix
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.initrd.luks.devices."luks-8ab05525-f7cc-435a-9c91-7e2e45f22977".device =
        "/dev/disk/by-uuid/8ab05525-f7cc-435a-9c91-7e2e45f22977";
      boot.kernelPackages = pkgs.linuxPackages_lqx;
      boot.extraModprobeConfig = "options kvm_intel nested=1";
      boot.tmp.cleanOnBoot = true;

      services.btrfs.autoScrub.enable = true;
      services.btrfs.autoScrub.fileSystems = [ "/" ];
      services.btrfs.autoScrub.interval = "weekly";

      zramSwap.enable = true;
    };
}
