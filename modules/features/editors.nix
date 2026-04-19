{ lib, inputs, ... }:
{
  flake-file.inputs.nix-doom-emacs-unstraightened = {
    url = lib.mkDefault "github:marienz/nix-doom-emacs-unstraightened";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.homeManager.options-editors =
    {
      lib,
      config,
      pkgs,
      ...
    }:
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
          extraPackages = epkgs: [
            (epkgs.melpaBuild {
              pname = "hel";
              version = "0.10.0";
              packageRequires = [
                epkgs.avy
                epkgs.dash
                epkgs.pcre2el
              ];
              src = pkgs.fetchFromGitHub {
                owner = "anuvyklack";
                repo = "hel";
                rev = "489f48a1bb8b41a8b681821ecbfc4a7cb33fc5c0";
                sha256 = "sha256-n/aplUWdlAI0kyEhif3oikaAILFQDoRM+ohEqvHKBIs=";
              };
            })
          ];
        };
      };
    };
}
