{ lib, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = lib.mkForce "nixpkgs";
  };
}
