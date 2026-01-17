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
    services.pipewire.extraConfig.jack = {
      "10-clock-rate" = {
        "jack.properties" = {
          "node.latency" = "128/48000";
          "node.rate" = "1/48000";
          "node.lock-quantum" = true;
        };
      };
    };

    environment.systemPackages = [ pkgs.qpwgraph ];
  };
}
