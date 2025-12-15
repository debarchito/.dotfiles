{ lib, config, ... }:

{
  options.bluetooth.enable = lib.mkEnableOption "enable bluetooth module";

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Experimental = true;
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    systemd.services.rfkill-unlock-bluetooth = {
      description = "rkill unlock bluetooth";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/rfkill unblock bluetooth";
        User = "root";
      };
    };
  };
}
