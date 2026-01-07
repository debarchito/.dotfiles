{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.android.enable = lib.mkEnableOption "enable android module";

  config = lib.mkIf config.android.enable {
    environment.systemPackages = [
      pkgs.android-tools
    ];
  };
}
