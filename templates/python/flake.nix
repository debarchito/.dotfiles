{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      treefmt-nix,
      ...
    }:
    let
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
      overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
      editableOverlay = workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };
    in
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
        { pkgs, config, ... }:
        let
          lib = pkgs.lib;

          src = lib.cleanSource ./.;

          pythonSet =
            (pkgs.callPackage pyproject-nix.build.packages {
              python = pkgs.python314;
            }).overrideScope
              (
                lib.composeManyExtensions [
                  pyproject-build-systems.overlays.wheel
                  overlay
                ]
              );
          editablePythonSet = pythonSet.overrideScope editableOverlay;

          venv = pythonSet.mkVirtualEnv "{{name:k}}-env" workspace.deps.default // {
            meta.mainProgram = "{{name:k}}";
          };
          devVenv = editablePythonSet.mkVirtualEnv "{{name:k}}-dev-env" workspace.deps.all;
        in
        {
          packages = {
            {{name:k}} = venv;
            default = venv;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              ruff-check.enable = true;
              ruff-format.enable = true;
              taplo.enable = true;
            };
          };

          checks = {
            inherit (config.packages) {{name:k}};

            {{name:k}}-pyright =
              pkgs.runCommand "{{name:k}}-pyright"
                {
                  buildInputs = [
                    devVenv
                    pkgs.basedpyright
                  ];
                  PYTHONPATH = "${devVenv}/${pythonSet.python.sitePackages}";
                }
                ''
                  cd ${src}
                  XDG_CACHE_HOME=/tmp/cache basedpyright
                  touch $out
                '';
          };

          overlayAttrs = {
            inherit (config.packages) {{name:k}};
          };

          devShells.default = pkgs.mkShell {
            name = "{{name:k}}-dev";

            packages = [
              devVenv
              pkgs.uv
              pkgs.basedpyright
              pkgs.ruff
            ];

            env = {
              UV_NO_SYNC = "1";
              UV_PYTHON = pythonSet.python.interpreter;
              UV_PYTHON_DOWNLOADS = "never";
            };

            shellHook = ''
              unset PYTHONPATH
              export REPO_ROOT=$(${lib.getExe pkgs.git} rev-parse --show-toplevel 2>/dev/null || pwd)
            '';
          };
        };
    };
}
