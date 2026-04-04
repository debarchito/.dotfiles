{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    systems.url = "github:nix-systems/default";
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
      systems,
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

      systems = import systems;

      perSystem =
        { system, config, ... }:
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
            // rec {
              pname = "{{name:k}}";
              version = "0.1.0";

              inherit cargoArtifacts;

              postInstall = ''
                export HOME=$(mktemp -d)
                mkdir -p $out/share/bash-completion/completions
                $out/bin/${pname} completion bash > $out/share/bash-completion/completions/${pname}
                mkdir -p $out/share/zsh/site-functions
                $out/bin/${pname} completion zsh > $out/share/zsh/site-functions/_${pname}
                mkdir -p $out/share/fish/vendor_completions.d
                $out/bin/${pname} completion fish > $out/share/fish/vendor_completions.d/${pname}.fish
                mkdir -p $out/share/elvish/lib
                $out/bin/${pname} completion elvish > $out/share/elvish/lib/${pname}.elv
                mkdir -p $out/share/powershell/Modules/${pname}
                $out/bin/${pname} completion powershell > $out/share/powershell/Modules/${pname}/${pname}.psm1
                mkdir -p $out/share/nushell/vendor/autoload
                $out/bin/${pname} completion nushell > $out/share/nushell/vendor/autoload/${pname}.nu
              '';
            }
          );
        in
        {
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

            {{name:k}}-fmt = craneLib.cargoFmt {
              inherit src;
            };

            {{name:k}}-audit = craneLib.cargoAudit {
              inherit src advisory-db;
            };
          };

          overlayAttrs = {
            inherit (config.packages) {{name:k}};
          };

          devShells.default = craneLib.devShell {
            name = "{{name:k}}-dev";
            checks = config.checks;
            inherit (commonArgs) RUSTFLAGS;
          };
        };
    };
}
