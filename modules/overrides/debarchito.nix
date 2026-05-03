{
  lib,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs.nixpkgs-1.url = lib.mkDefault "github:nixos/nixpkgs/1c3fe55ad329cbcb28471bb30f05c9827f724c76";

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  flake.modules.nixos.users-debarchito = moduleWithSystem (
    { self', system, ... }:
    let
      pkgs-1 = import inputs.nixpkgs-1 {
        inherit system;
      };
    in
    {
      nixpkgs.overlays = [
        (_: prev: {
          inherit (self'.packages) waydroid-choose-gpu waydroid-script;
          wireshark = pkgs-1.wireshark;
        })
      ];
    }
  );

  flake.modules.homeManager.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (self'.packages)
            blender
            generate
            helium
            neuralrack
            obs-studio
            papirus-folders
            qt6ct
            ratatouille
            reaper
            sioyek
            starship-jj
            ;
        })
      ];
    }
  );
}
