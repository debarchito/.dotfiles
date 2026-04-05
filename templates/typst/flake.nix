{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, lib, ... }:
        let
          sioyek = pkgs.sioyek.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
            postInstall = (old.postInstall or "") + ''
              wrapProgram $out/bin/sioyek --set QT_QPA_PLATFORM xcb
            '';
          });

          build =
            pkgs.writers.writeFishBin "build" { }
              # fish
              ''
                ${lib.getExe' pkgs.coreutils "mkdir"} -p $ROOT/_build

                ${lib.getExe pkgs.typst} compile $ROOT/src/{{name:TS}}.typ $ROOT/_build/{{name:TS}}.pdf
              '';

          develop =
            pkgs.writers.writeFishBin "develop" { }
              # fish
              ''
                ${lib.getExe' pkgs.coreutils "mkdir"} -p $ROOT/_build

                ${lib.getExe pkgs.typst} watch $ROOT/src/{{name:TS}}.typ $ROOT/_build/{{name:TS}}.pdf &
                set TYPST_PID $last_pid

                ${lib.getExe sioyek} $ROOT/_build/{{name:TS}}.pdf

                kill $TYPST_PID
              '';
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              typstyle.enable = true;
            };
          };

          devShells.default = pkgs.mkShellNoCC {
            name = "{{name:k}}-dev";

            packages = [
              pkgs.typst
              pkgs.tinymist
              sioyek
              build
              develop
            ];

            shellHook = ''
              export ROOT=$(${lib.getExe pkgs.git} rev-parse --show-toplevel 2>/dev/null || pwd)
            '';
          };
        };
    };
}
