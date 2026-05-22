{ lib, inputs, ... }:
{
  flake-file.inputs.pinentry-dms = {
    url = lib.mkDefault "github:debarchito/dankpinentry";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  perSystem =
    { system, ... }:
    {
      packages.pinentry-dms = inputs.pinentry-dms.packages.${system}.pinentry-dms;
    };
}
