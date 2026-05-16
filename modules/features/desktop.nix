{
  flake.modules.nixos.options-desktop =
    { lib, config, ... }:
    {
      options.desktop = lib.mkOption {
        type = lib.types.submodule {
          options = {
            niri.enable = lib.mkEnableOption "enable unstable niri builds";
            labwc.enable = lib.mkEnableOption "enable labwc";
          };
        };
        default = { };
      };

      config = lib.mkIf config.desktop.labwc.enable {
        programs.labwc.enable = true;
      };
    };

  flake.modules.homeManager.options-desktop =
    { lib, config, ... }:
    {
      options.desktop = lib.mkOption {
        type = lib.types.submodule {
          options = {
            niri.enable = lib.mkEnableOption "enable my niri setup";
            niri.dms.enable = lib.mkEnableOption "enable my dank-material-shell setup for niri";
            labwc.dms.enable = lib.mkEnableOption "enable my dank-material-shell setup for labwc";
          };
        };
        default = { };
      };

      config = lib.mkIf config.desktop.labwc.dms.enable {
        xdg.configFile."labwc/autostart".text = "dms run &";
      };
    };
}
