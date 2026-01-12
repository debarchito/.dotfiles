{ pkgs, userName, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hosts/bluetooth.nix
    ../../modules/hosts/common-settings.nix
    ../../modules/hosts/graphics.nix
    ../../modules/hosts/netmod.nix
    ../../modules/hosts/pipewire.nix
    ../../modules/hosts/podman.nix
    ../../modules/hosts/steam.nix
    ../../modules/hosts/sunshine.nix
    ../../modules/hosts/trusted-substituters.nix
    ../../modules/hosts/vm.nix
  ];

  system.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;

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

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
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

  common-settings.enable = true;
  common-settings.flake = "/home/${userName}/.dotfiles";
  common-settings.gcOptions = "--delete-older-than 7d";
  trusted-substituters.enable = true;

  netmod.enable = true;
  netmod.name = "laptop";
  netmod.allowPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  netmod.openssh.enable = true;
  netmod.openssh.ports = [ 54321 ];
  netmod.openssh.allowUsers = [ userName ];
  netmod.openssh.endlessh.port = 22;
  netmod.openvpn.enable = true;

  bluetooth.enable = true;
  pipewire.enable = true;

  graphics.enable = true;
  graphics.nvidia.enable = true;
  graphics.nvidia.prime.enable = true;
  graphics.nvidia.prime.offload.enable = true;
  graphics.nvidia.prime.intelBusId = "PCI:0:2:0";
  graphics.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

  podman.enable = true;
  podman.settings = {
    dns_enabled = true;
  };
  vm.enable = true;
  vm.kvm.enable = true;

  services.flatpak.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.libxcrypt
      pkgs.icu
    ];
  };

  steam.enable = true;
  sunshine.enable = true;

  users.users.${userName} = {
    isNormalUser = true;
    description = "${userName}'s account";
    extraGroups = [
      "bluetooth"
      "kvm"
      "libvirtd"
      "networkmanager"
      "pipewire"
      "plugdev"
      "wheel"
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ZED_WINDOW_DECORATIONS = "server";
  };
}
