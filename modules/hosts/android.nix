{ lib, config, ... }:

{
  options.android.enable = lib.mkEnableOption "enable android module";

  config = lib.mkIf config.android.enable {
    programs.adb.enable = true;
  };
}
