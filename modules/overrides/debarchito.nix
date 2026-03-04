{
  lib,
  moduleWithSystem,
  inputs,
  ...
}:
{
  flake-file.inputs.nixpkgs-1.url = lib.mkDefault "github:nixos/nixpkgs/e4bf2a3807d74a0634fdc17de7622ce1be9c8cee";

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  flake.modules.homeManager.users-debarchito = moduleWithSystem (
    { system, ... }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (inputs.nixpkgs-1.legacyPackages.${system})
            gearlever
            zed-editor
            ;
        })
      ];
    }
  );
}
