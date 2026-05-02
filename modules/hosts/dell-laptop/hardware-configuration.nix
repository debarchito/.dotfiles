let
  name = "dell-laptop";
in
{
  flake.modules.nixos."hosts-${name}" =
    { pkgs, ... }:
    {
      # NOTE: Raw files are treated as external dependencies thus, are a special case for relative imports.
      imports = [
        ./_raw/hardware-configuration.nix
        # ./_raw/disko-configuration.nix
      ];

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        initrd.luks.devices."luks-8ab05525-f7cc-435a-9c91-7e2e45f22977".device =
          "/dev/disk/by-uuid/8ab05525-f7cc-435a-9c91-7e2e45f22977";
        kernelPackages = pkgs.linuxPackages_xanmod_latest;
        kernelModules = [ "ntsync" ];
        extraModprobeConfig = "options kvm_intel nested=1";
        tmp.cleanOnBoot = true;
      };

      services.btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
        interval = "weekly";
      };

      zramSwap.enable = true;
    };
}
