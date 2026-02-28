{
  lib,
  moduleWithSystem,
  inputs,
  ...
}:
{
  flake-file.inputs.nixpkgs-1.url = lib.mkDefault "github:nixos/nixpkgs/7d1e6f1288a41e5fdbd4c5c82d495b51d49511a4";

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  flake.modules.nixos.users-debarchito = moduleWithSystem (
    { system, ... }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (inputs.nixpkgs-1.legacyPackages.${system})
            sunshine
            ;
        })
      ];
    }
  );

  flake.modules.homeManager.users-debarchito = moduleWithSystem (
    { system, ... }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (inputs.nixpkgs-1.legacyPackages.${system})
            gearlever
            khal
            krita
            ;
        })
      ];
    }
  );
}
