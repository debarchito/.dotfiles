{ lib, config, ... }:

{
  options.sunshine.enable = lib.mkEnableOption "enable sunshine module";

  config = lib.mkIf config.sunshine.enable {
    services.sunshine.enable = true;
    services.sunshine.autoStart = false;
    services.sunshine.capSysAdmin = true;
    services.sunshine.openFirewall = true;
  };
}
