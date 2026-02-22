{ lib, inputs, ... }:
{
  flake-file.inputs = {
    home-manager.url = lib.mkDefault "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
}
