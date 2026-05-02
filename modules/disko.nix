{ lib, ... }:
{
  flake-file.inputs.disko = {
    url = lib.mkDefault "github:nix-community/disko";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };
}
