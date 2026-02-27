{ lib, inputs, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-1.url = lib.mkDefault "github:nixos/nixpkgs/7d1e6f1288a41e5fdbd4c5c82d495b51d49511a4";
    nixpkgs-lib.follows = lib.mkForce "nixpkgs";
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
