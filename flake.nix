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
    snippets-ls = {
      url = "github:quantonganh/snippets-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      nix-flatpak,
      nixgl,
      nur,
      home-manager,
      system-manager,
      snippets-ls,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-overlay = final: prev: {
        inherit nixgl;
        snippets-ls = snippets-ls.packages.${prev.system}.snippets-ls;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkgs: true);
        overlays = [
          pkgs-overlay
          nur.overlays.default
        ];
      };
      pkgs-stable = import nixpkgs-stable { inherit system; };
    in
    {
      formatter.${system} = pkgs.treefmt;
      homeConfigurations.debarchito = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nix-flatpak.homeManagerModules.nix-flatpak
          ./home.nix
        ];
      };
      systemConfigs.dell = system-manager.lib.makeSystemConfig {
        extraSpecialArgs = { inherit pkgs-stable; };
        modules = [ ./system.nix ];
      };
    };
}
