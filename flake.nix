{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
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
    pulse-visualizer = {
      url = "github:debarchito/pulse-visualizer/f0a91f128e92a5e725440ca6b4512d32ef040627";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dcachix = {
      url = "github:debarchito/dcachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      systemName = "laptop";
      userName = "debarchito";

      overlay = final: prev: {
        xwayland-satellite = inputs.xwayland-satellite.packages.${system}.default;
      };

      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.niri.overlays.niri
          inputs.nix-alien.overlays.default
          inputs.helix.overlays.default
          inputs.minework.overlays.default
          inputs.pulse-visualizer.overlays.default
          inputs.nur.overlays.default
          inputs.dcachix.overlays.default
          overlay
        ];
      };
    in
    {
      nixosConfigurations.${systemName} = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs' = pkgs;
          inherit inputs userName;
        };
        modules = [
          inputs.niri.nixosModules.niri
          ./hosts/${systemName}
          ./modules/desktop
        ];
      };

      homeConfigurations.${userName} = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.niri.homeModules.config
          inputs.dms.homeModules.niri
          inputs.dms.homeModules.dank-material-shell
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ./homes/${userName}
        ];
      };
    };
}
