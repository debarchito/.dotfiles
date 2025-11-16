{ lib, config, ... }:

{
  options.netmod = {
    enable = lib.mkEnableOption "enable networking module";
    name = lib.mkOption {
      description = "the networking hostName";
    };
    openssh = {
      enable = lib.mkEnableOption "enable openssh module";
      allowUsers = lib.mkOption {
        description = "list of allowed users";
      };
      ports = lib.mkOption {
        description = "ports to run on";
      };
      endlessh.port = lib.mkOption {
        description = "port endlessh will listen on";
      };
    };
    openvpn.enable = lib.mkEnableOption "enable openvpn module";
  };

  config = lib.mkMerge [
    (lib.mkIf config.netmod.enable {
      networking = {
        hostName = config.netmod.name;
        networkmanager.enable = true;
        firewall = rec {
          allowedTCPPortRanges = [
            # KDE Connect (managed by home-manager)
            {
              from = 1714;
              to = 1764;
            }
          ];
          allowedUDPPortRanges = allowedTCPPortRanges;
        };
      };
    })

    (lib.mkIf (config.netmod.enable && config.netmod.openssh.enable) {
      services.openssh = {
        enable = true;
        ports = config.netmod.openssh.ports;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = config.netmod.openssh.allowUsers;
        };
        openFirewall = true;
      };
      services.endlessh = {
        enable = true;
        port = config.netmod.openssh.endlessh.port;
        openFirewall = true;
      };
    })

    (lib.mkIf (config.netmod.enable && config.netmod.openvpn.enable) {
      programs.openvpn3.enable = true;
    })
  ];
}
