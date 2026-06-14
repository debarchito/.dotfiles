{ lib, inputs, ... }:
{
  flake-file.inputs.nix-doom-emacs-unstraightened = {
    url = lib.mkDefault "github:marienz/nix-doom-emacs-unstraightened";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.homeManager.options-editors =
    { lib, config, ... }:
    {
      imports = [
        inputs.nix-doom-emacs-unstraightened.homeModule
      ];

      options.editors = lib.mkOption {
        type = lib.types.submodule {
          options = {
            doom-emacs.enable = lib.mkEnableOption "enable doom emacs";
            zed-editor.enable = lib.mkEnableOption "enable zed editor";
          };
        };
        default = { };
      };

      config = lib.mkIf config.editors.doom-emacs.enable {
        programs.doom-emacs = {
          enable = true;
          doomDir = ./editors/doom-emacs;
        };
      };
    };
}
