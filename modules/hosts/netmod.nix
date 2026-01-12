{ lib, config, ... }:

{
  options.netmod = {
    enable = lib.mkEnableOption "enable networking module";
    name = lib.mkOption { description = "the networking hostName"; };
    allowPortRanges = lib.mkOption { description = "open specific ports for both TCP and UDP"; };
    openssh.enable = lib.mkEnableOption "enable openssh module";
    openssh.allowUsers = lib.mkOption { description = "list of allowed users"; };
    openssh.ports = lib.mkOption { description = "ports to run on"; };
    openssh.endlessh.port = lib.mkOption { description = "port endlessh will listen on"; };
    openvpn.enable = lib.mkEnableOption "enable openvpn module";
  };

  config = lib.mkMerge [
    (lib.mkIf config.netmod.enable {
      networking.hostName = config.netmod.name;
      networking.networkmanager.enable = true;
      networking.firewall.allowedTCPPortRanges = config.netmod.allowPortRanges;
      networking.firewall.allowedUDPPortRanges = config.netmod.allowPortRanges;
    })

    (lib.mkIf (config.netmod.enable && config.netmod.openssh.enable) {
      services.openssh.enable = true;
      services.openssh.ports = config.netmod.openssh.ports;
      services.openssh.openFirewall = true;
      services.openssh.settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = config.netmod.openssh.allowUsers;
      };

      services.endlessh.enable = true;
      services.endlessh.port = config.netmod.openssh.endlessh.port;
      services.endlessh.openFirewall = true;
    })

    (lib.mkIf (config.netmod.enable && config.netmod.openvpn.enable) {
      programs.openvpn3.enable = true;
    })
  ];
}
