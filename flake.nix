{
  description = "Root flake for my Pop!_OS setup";
  inputs = {
    flake-root.url = "github:srid/flake-root";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      systems = [ system ];
      flake = {
        homeConfigurations = {
          debarchito = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
          };
        };
        systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
          modules = [ ./modules ];
        };
      };
      perSystem =
        { config, ... }:
        {
          # Configure all the formatters in one place
          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            programs.just.enable = true;
            programs.deno.enable = true;
            programs.nixfmt.enable = true;
            programs.stylua.enable = true;
            programs.yamlfmt.enable = true;
            programs.jsonfmt.enable = true;
            programs.toml-sort.enable = true;
            programs.fish_indent.enable = true;
          };
        };
    };
}
