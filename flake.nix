# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    dms = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AvengeMedia/DankMaterialShell";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    musnix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:musnix/musnix";
    };
    niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:sodiboo/niri-flake";
    };
    nix-alien = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:thiagokokada/nix-alien";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-1.url = "github:nixos/nixpkgs/7d1e6f1288a41e5fdbd4c5c82d495b51d49511a4";
    nixpkgs-lib.follows = "nixpkgs";
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
    starship-jj = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:lanastara_foss/starship-jj";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    xwayland-satellite = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Supreeeme/xwayland-satellite";
    };
  };

}
