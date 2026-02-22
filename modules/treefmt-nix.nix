{ lib, inputs, ... }:
{
  flake-file.inputs = {
    treefmt-nix.url = lib.mkDefault "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { self', ... }:
    {
      packages.fmt = self'.formatter;
      treefmt = {
        projectRoot = inputs.flake-file;
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          nixf-diagnose.enable = true;
        };
        settings.on-unmatched = "fatal";
      };
    };
}
