{ lib, inputs, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
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
