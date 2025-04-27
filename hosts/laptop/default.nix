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
    ../../modules/sunshine.nix
  ];

  # Some stuff that should exist independently.
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  # Firmware stuff.
  services.fwupd.enable = true;

  # Fine-grained boot stuff.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c6aca288-6a62-4c22-8fc2-949a4a9c7bad".device =
    "/dev/disk/by-uuid/c6aca288-6a62-4c22-8fc2-949a4a9c7bad";
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fine-grained localization stuff.
  time.timeZone = "Asia/Kolkata";
  i18n.supportedLocales = [
    "en_IN/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_IN";
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_NAME = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
    LC_MESSAGES = "en_IN";
    LC_COLLATE = "en_IN";
    # Use different locale for these
    LC_MONETARY = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
  };

  # Miscellaneous stuff.
  common-settings.enable = true;
  trusted-substituters.enable = true;
  security.enable = true;

  # Networking stuff.
  netmod.enable = true;
  netmod.name = "laptop";

  # Media stuff.
  bluetooth.enable = true;
  pipewire.enable = true;

  # Display Manager stuff.
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = [
    pkgs.kdePackages.discover
    pkgs.kdePackages.elisa
    pkgs.kdePackages.kate
  ];

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
  vm.waydroid.enable = true;

  # Sunshine (and Moonlight) stuff.
  sunshine.enable = true;

  # Flatpak stuff.
  services.flatpak.enable = true;

  # AppImage stuff.
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Nix-ld.
  programs.nix-ld.enable = true;

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
      "kvm"
    ];
  };

  # Variables stuff.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
