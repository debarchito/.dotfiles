{
  description = "Root flake for my Pop!_OS setup";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, nixpkgs-stable, nix-flatpak, nixgl, nur, home-manager, system-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkgs: true);
        overlays = [ nur.overlays.default ];
      };
      pkgs-stable = import nixpkgs-stable { inherit system; };
    in
    {
      homeConfigurations.debarchito = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit nixgl; inherit pkgs-stable; };
        modules = [
          nix-flatpak.homeManagerModules.nix-flatpak
          ./home.nix
        ];
      };
      systemConfigs.default = system-manager.lib.makeSystemConfig {
        extraSpecialArgs = { inherit pkgs-stable; };
        modules = [ ./system.nix ];
      };
    };
}
