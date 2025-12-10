{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    dcachix.url = "github:debarchito/dcachix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minework = {
      url = "git+https://codeberg.org/debarchito/minework";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        starship-jj = inputs.starship-jj.packages.${system}.default;
      };
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.dcachix.overlays.default
          inputs.helix.overlays.default
          inputs.nur.overlays.default
          inputs.niri.overlays.niri
          inputs.nix-alien.overlays.default
          inputs.minework.overlays.default
          overlay
        ];
      };
    in
    {
      nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop
          ./modules/games
          ./modules/wm
        ];
      };
      homeConfigurations.debarchito = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.niri.homeModules.niri
          inputs.dankMaterialShell.homeModules.dankMaterialShell.default
          inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
          ./homes/debarchito
        ];
      };
    };
}
