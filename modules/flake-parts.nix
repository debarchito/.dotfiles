{ lib, inputs, ... }:
{
  flake-file.inputs.flake-parts = {
    url = lib.mkDefault "github:hercules-ci/flake-parts";
    inputs.nixpkgs-lib.follows = lib.mkForce "nixpkgs-lib";
  };

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
