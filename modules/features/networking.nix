{
  flake.modules.nixos.options-networking' =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options = {
        networking'.enable = lib.mkEnableOption "enable networking";
        networking'.name = lib.mkOption {
          type = lib.types.str;
          default = "nixos";
          description = "the networking hostName";
        };
        networking'.allowPortRanges = lib.mkOption {
          type = lib.types.listOf (lib.types.attrsOf lib.types.int);
          default = [ ];
          description = "open specific ports for both TCP and UDP";
        };
        networking'.manager.enable = lib.mkEnableOption "enable networkmanager";
        networking'.openssh.enable = lib.mkEnableOption "enable openssh";
        networking'.openssh.ports = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [ 22 ];
          description = "ports to run on";
        };
        networking'.openssh.settings = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "extra settings for services.openssh.settings";
        };
        networking'.openssh.endlessh.port = lib.mkOption {
          type = lib.types.port;
          default = 2222;
          description = "port endlessh will listen on";
        };
        networking'.openvpn.enable = lib.mkEnableOption "enable openvpn";
        networking'.wireshark.enable = lib.mkEnableOption "enable wireshark";
      };

      config = lib.mkIf config.networking'.enable (
        lib.mkMerge [
          {
            networking.hostName = config.networking'.name;
            networking.firewall.allowedTCPPortRanges = config.networking'.allowPortRanges;
            networking.firewall.allowedUDPPortRanges = config.networking'.allowPortRanges;
          }

          (lib.mkIf config.networking'.manager.enable {
            networking.networkmanager.enable = true;

            programs.nm-applet.enable = true;
          })

          (lib.mkIf config.networking'.openssh.enable {
            services.openssh.enable = true;
            services.openssh.ports = config.networking'.openssh.ports;
            services.openssh.openFirewall = true;
            services.openssh.settings = lib.mkMerge [
              {
                PasswordAuthentication = lib.mkDefault false;
                KbdInteractiveAuthentication = lib.mkDefault false;
                PermitRootLogin = lib.mkDefault "no";
              }
              config.networking'.openssh.settings
            ];
            services.endlessh.enable = true;
            services.endlessh.port = config.networking'.openssh.endlessh.port;
            services.endlessh.openFirewall = true;
          })

          (lib.mkIf config.networking'.openvpn.enable {
            programs.openvpn3.enable = true;
          })

          (lib.mkIf config.networking'.wireshark.enable {
            programs.wireshark.enable = true;
            programs.wireshark.package = pkgs.wireshark;
          })
        ]
      );
    };
}
