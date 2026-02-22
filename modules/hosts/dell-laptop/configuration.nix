{ inputs, self, ... }:
let
  name = "dell-laptop";
in
{
  flake.nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.determinate.nixosModules.default
      self.modules.nixos.options-common
      self.modules.nixos.options-trustedSubstituters
      self.modules.nixos.options-networking'
      self.modules.nixos.options-graphics
      self.modules.nixos.options-media
      self.modules.nixos.options-containers'
      self.modules.nixos.options-qemu
      self.modules.nixos.options-desktop
      self.modules.nixos.options-packaging
      self.modules.nixos.options-gaming
      self.modules.nixos."hosts-${name}"
      self.modules.nixos.users-debarchito
    ];
  };

  flake.modules.nixos."hosts-${name}" = {
    system.stateVersion = "24.11";

    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Asia/Kolkata";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_IN";
        LC_IDENTIFICATION = "en_IN";
        LC_MEASUREMENT = "en_IN";
        LC_MONETARY = "en_IN";
        LC_NAME = "en_IN";
        LC_NUMERIC = "en_IN";
        LC_PAPER = "en_IN";
        LC_TELEPHONE = "en_IN";
        LC_TIME = "en_IN";
      };
    };

    common = {
      enable = true;
      desktop.enable = true;
    };

    trustedSubstituters.enable = true;

    networking' = {
      enable = true;
      inherit name;
      manager.enable = true;
    };

    graphics = {
      enable = true;
      nvidia = {
        enable = true;
        prime = {
          enable = true;
          settings = {
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
          };
        };
      };
    };

    media.enable = true;
  };
}
