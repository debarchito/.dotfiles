{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hosts/common-settings.nix
    ../../modules/hosts/trusted-substituters.nix
    ../../modules/hosts/security.nix
    ../../modules/hosts/netmod.nix
    ../../modules/hosts/bluetooth.nix
    ../../modules/hosts/pipewire.nix
    ../../modules/hosts/graphics.nix
    ../../modules/hosts/podman.nix
    ../../modules/hosts/vm.nix
    ../../modules/hosts/sunshine.nix
    ../../modules/hosts/android.nix
  ];

  # Some stuff that should exist independently.
  system.stateVersion = "24.11";
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  # Firmware stuff.
  services.fwupd.enable = true;

  # Fine-grained boot stuff.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c6aca288-6a62-4c22-8fc2-949a4a9c7bad".device =
    "/dev/disk/by-uuid/c6aca288-6a62-4c22-8fc2-949a4a9c7bad";
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Zram stuff.
  zramSwap.enable = true;

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
  common-settings.flake = "/home/debarchito/.dotfiles";
  common-settings.gc.options = "--delete-older-than 7d";
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

  # Graphics stuff.
  graphics.enable = true;
  graphics.nvidia.enable = true;
  graphics.nvidia.prime = {
    enable = true;
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Virtualization stuff.
  podman.enable = true;
  vm.enable = true;
  vm.kvm.enable = true;
  # vm.waydroid.enable = true;

  # Sunshine (and Moonlight) stuff.
  sunshine.enable = true;

  # Flatpak stuff.
  services.flatpak.enable = true;

  # AppImage stuff.
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.libxcrypt
      pkgs.icu
    ];
  };

  # Nix-ld.
  programs.nix-ld.enable = true;

  # OpenSHH
  services.openssh.enable = true;

  # Android
  android.enable = true;

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
      "adbusers"
    ];
  };

  # Variables stuff.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ZED_WINDOW_DECORATIONS = "server";
    SIGNAL_PASSWORD_STORE = "kwallet6";
  };
}
