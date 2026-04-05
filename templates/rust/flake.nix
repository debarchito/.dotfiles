{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    crane.url = "github:ipetkov/crane";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      crane,
      rust-overlay,
      advisory-db,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.easyOverlay
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import rust-overlay)
            ];
          };

          toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
          craneLib = (crane.mkLib pkgs).overrideToolchain toolchain;

          src = craneLib.cleanCargoSource ./.;
          commonArgs = {
            inherit src;
            strictDeps = true;
            nativeBuildInputs = [ pkgs.mold ];
            RUSTFLAGS = "-Clink-args=-fuse-ld=mold";
          };

          cargoArtifacts = craneLib.buildDepsOnly commonArgs;

          {{name:k}} = craneLib.buildPackage (
            commonArgs
            // {
              pname = "{{name:k}}";
              version = "0.1.0";
              inherit cargoArtifacts;
            }
          );
        in
        rec {
          packages = {
            inherit {{name:k}};
            default = {{name:k}};
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              rustfmt = {
                enable = true;
                package = toolchain;
              };
              taplo.enable = true;
            };
          };

          checks = {
            inherit {{name:k}};

            {{name:k}}-clippy = craneLib.cargoClippy (
              commonArgs
              // {
                inherit cargoArtifacts;
                cargoClippyExtraArgs = "--all-targets -- --deny warnings";
              }
            );

            {{name:k}}-audit = craneLib.cargoAudit {
              inherit src advisory-db;
            };
          };

          overlayAttrs = {
            inherit {{name:k}};
          };

          devShells.default = craneLib.devShell {
            name = "{{name:k}}-dev";
            inherit checks;
            inherit (commonArgs) RUSTFLAGS;
          };
        };
    };
}
