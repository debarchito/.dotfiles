{ lib, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = lib.mkForce "nixpkgs";
  };
}
