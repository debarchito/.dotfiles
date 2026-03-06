{ lib, ... }:
{
  flake-file.inputs.systems.url = lib.mkDefault "github:nix-systems/default";
}
