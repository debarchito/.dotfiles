{ lib, inputs, ... }:
{
  flake-file.inputs.starship-jj = {
    url = lib.mkDefault "gitlab:lanastara_foss/starship-jj";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  perSystem =
    { system, ... }:
    {
      packages.starship-jj = inputs.starship-jj.packages.${system}.default;
    };
}
