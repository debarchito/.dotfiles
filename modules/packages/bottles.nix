{ lib, inputs, ... }:
{
  flake-file.inputs.nixpkgs-bottles.url = lib.mkDefault "github:nixos/nixpkgs/31cb51ac29587750441d5a80d7f7a41bf8b20fad";

  perSystem =
    { system, ... }:
    let
      pkgs-bottles = import inputs.nixpkgs-bottles {
        inherit system;
        overlays = [
          (final: prev: {
            # NOTE: Skipping tests while upstream sorts it out, revert once Hydra consistently builds openldap green.
            openldap = prev.openldap.overrideAttrs (_: {
              doCheck = !prev.stdenv.hostPlatform.isi686;
            });
          })
        ];
      };
    in
    {
      packages.bottles = pkgs-bottles.bottles.override {
        removeWarningPopup = true;
      };
    };
}
