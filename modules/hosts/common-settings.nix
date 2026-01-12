{ lib, config, ... }:

{
  options.common-settings = {
    enable = lib.mkEnableOption "common settings that can be utilized for multiple hosts";
    flake = lib.mkOption {
      description = "path to the flake to use";
    };
    gcOptions = lib.mkOption {
      description = "additional options for gc";
    };
  };

  config = lib.mkIf config.common-settings.enable {
    security.polkit.enable = true;
    security.rtkit.enable = true;

    services.colord.enable = true;
    services.fail2ban.enable = true;
    services.fwupd.enable = true;
    services.printing.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    nix.settings.auto-optimise-store = true;

    programs.nix-ld.enable = true;

    programs.nh.enable = true;
    programs.nh.flake = config.common-settings.flake;
    programs.nh.clean.enable = true;
    programs.nh.clean.extraArgs = config.common-settings.gcOptions;
  };
}
