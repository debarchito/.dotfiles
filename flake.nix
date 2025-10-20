{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-pin-1.url = "github:nixos/nixpkgs/544961dfcce86422ba200ed9a0b00dd4b1486ec5"; # For Kernel, 6.17.2
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    catppuccin.url = "github:catppuccin/nix";
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
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.dcachix.overlays.default
          inputs.helix.overlays.default
          inputs.nur.overlays.default
          inputs.nix-alien.overlays.default
        ];
      };
      pkgs-pin-1 = import inputs.nixpkgs-pin-1 {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-pin-1; };
        modules = [
          ./hosts/laptop
          ./modules/games
          ./modules/wm
        ];
      };
      homeConfigurations.debarchito = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.catppuccin.homeModules.catppuccin
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ./homes/debarchito
        ];
      };
    };
}
