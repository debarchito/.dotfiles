{
  lib,
  pkgs,
  config,
  ...
}:

{
  options.pipewire.enable = lib.mkEnableOption "enable pipewire module";

  config = lib.mkIf config.pipewire.enable {
    services.pipewire.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.pulse.enable = true;
    services.pipewire.jack.enable = true;
    services.pipewire.wireplumber.enable = true;

    environment.systemPackages = [
      pkgs.qjackctl
      pkgs.qpwgraph
    ];
  };
}
