{
  flake.modules.homeManager.options-browsers =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.browsers = lib.mkOption {
        type = lib.types.submodule {
          options = {
            helium.enable = lib.mkEnableOption "enable helium";
            librewolf.enable = lib.mkEnableOption "enable my librewolf config";
          };
        };
        default = { };
      };

      config = lib.mkIf config.browsers.helium.enable {
        home.packages = builtins.attrValues {
          inherit (pkgs) helium;
        };
      };
    };
}
