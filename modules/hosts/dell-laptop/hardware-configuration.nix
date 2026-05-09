{ inputs, ... }:
let
  name = "dell-laptop";
in
{
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  flake.modules.nixos."hosts-${name}" =
    { pkgs, ... }:
    {
      # NOTE: Raw files are treated as external dependencies thus, are a special case for relative imports.
      imports = [
        ./_raw/hardware-configuration.nix
        # ./_raw/disko-configuration.nix
      ];

      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        initrd.luks.devices."luks-8ab05525-f7cc-435a-9c91-7e2e45f22977".device =
          "/dev/disk/by-uuid/8ab05525-f7cc-435a-9c91-7e2e45f22977";
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
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
