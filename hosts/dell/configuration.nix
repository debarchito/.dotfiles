{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common-settings.nix
    ../../modules/trusted-substituters.nix
    ../../modules/security.nix
    ../../modules/netmod.nix
    ../../modules/bluetooth.nix
    ../../modules/pipewire.nix
    ../../modules/graphics.nix
    ../../modules/podman.nix
    ../../modules/vm.nix
  ];

  # Some stuff that should exist independently.
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  # Miscellaneous stuff.
  common-settings.enable = true;
  trusted-substituters.enable = true;
  security.enable = true;

  # Networking stuff.
  netmod.enable = true;
  netmod.name = "dell";

  # Media stuff.
  bluetooth.enable = true;
  pipewire.enable = true;

  # Graphics stuff.
  graphics.enable = true;
  graphics.nvidia.enable = true;
  graphics.nvidia.prime.enable = true;
  graphics.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Virtualization stuff.
  podman.enable = true;
  vm.enable = true;
  vm.kvm.enable = true;

  # Boot stuff.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c6aca288-6a62-4c22-8fc2-949a4a9c7bad".device =
    "/dev/disk/by-uuid/c6aca288-6a62-4c22-8fc2-949a4a9c7bad";
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  # Don't use cachyos kernel due to regressions
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # services.scx.enable = true;

  # Localization stuff.
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Dislay Manager stuff.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.libinput.enable = true;
  programs.xwayland.enable = true;

  # Me!
  users.users.debarchito = {
    isNormalUser = true;
    description = "Debarchito Nath";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "bluetooth"
      "libvirtd"
    ];
  };
}
