{
  lib,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs.nixpkgs-1.url = lib.mkDefault "github:nixos/nixpkgs/b40629efe5d6ec48dd1efba650c797ddbd39ace0";

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
            git-branchless
            ;
        })
      ];
    }
  );
}
