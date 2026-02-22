{ lib, inputs, ... }:
{
  flake-file.inputs = {
    flake-parts.url = lib.mkDefault "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = lib.mkDefault "nixpkgs-lib";
  };

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
