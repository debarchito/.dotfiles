{ lib, config, ... }:

{
  options.common-settings = {
    enable = lib.mkEnableOption "common settings that can be utilized for multiple hosts";
    gc.options = lib.mkOption {
      description = "additional options for gc";
    };
    flake = lib.mkOption {
      description = "path to the flake to use";
    };
  };

  config = lib.mkIf config.common-settings.enable {
    services.printing.enable = true;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = config.common-settings.gc.options;
      flake = config.common-settings.flake;
    };
  };
}
