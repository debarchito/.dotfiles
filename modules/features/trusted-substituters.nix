{
  flake.modules.nixos.options-trustedSubstituters =
    { lib, config, ... }:
    {
      options.trustedSubstituters = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "enable pulling binary caches from trusted substituters";
          };
        };
        default = { };
      };

      config = lib.mkIf config.trustedSubstituters.enable {
        nix.settings.substituters = [
          "https://install.determinate.systems"
          "https://nix-community.cachix.org"
          "https://debarchito.cachix.org"
        ];
        nix.settings.trusted-public-keys = [
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "debarchito.cachix.org-1:md/bk3JZDoFjVOa6bsIDqaY5hcSec4KPWn8q3PbpCl8="
        ];
      };
    };
}
