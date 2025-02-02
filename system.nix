{
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

{
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    environment = {
      systemPackages =
        (with pkgs; [
          acpi
          apparmor-utils
          apparmor-parser
          docker
          nvme-cli
        ])
        ++ (with pkgs-stable; [
          quickemu
          qemu_kvm
        ]);
      etc = {
        "polkit-1/rules.d/50-libvirt.rules".text = ''
          polkit.addRule(function(action, subject) {
            if (action.id == "org.libvirt.unix.manage" &&
                subject.isInGroup("libvirt")) {
              return polkit.Result.YES;
            }
          });
        '';
      };
    };
    systemd.services = {
      docker = {
        enable = true;
        description = "Docker Application Container Engine";
        documentation = [ "https://docs.docker.com" ];
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "notify";
          Environment = [
            "PATH=${
              lib.makeBinPath [
                pkgs.apparmor-utils
                pkgs.apparmor-parser
                pkgs.coreutils
                pkgs.docker
                pkgs.kmod
              ]
            }:/usr/bin:/sbin"
          ];
          ExecStart = "${pkgs.docker}/bin/dockerd";
          ExecStartPost = [
            "${pkgs.coreutils}/bin/chmod 666 /var/run/docker.sock"
            "${pkgs.coreutils}/bin/chown root:docker /var/run/docker.sock"
          ];
          ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
          TimeoutStartSec = 0;
          RestartSec = 2;
          Restart = "always";
          StartLimitBurst = 3;
          StartLimitInterval = "60s";
          LimitNOFILE = "infinity";
          LimitNPROC = "infinity";
          LimitCORE = "infinity";
          TasksMax = "infinity";
          Delegate = true;
          KillMode = "process";
          OOMScoreAdjust = -500;
        };
      };
      libvirtd = {
        enable = true;
        serviceConfig = {
          Type = "simple";
        };
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs-stable.libvirt}/bin/libvirtd
        '';
      };
    };
  };
}
