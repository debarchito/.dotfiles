{
  perSystem =
    { pkgs, ... }:
    {
      packages.ratatouille = pkgs.stdenv.mkDerivation {
        pname = "ratatouille";
        version = "0.9.11-git";

        src = pkgs.fetchgit {
          url = "https://github.com/brummer10/Ratatouille.lv2.git";
          rev = "30aa06683fcd5dd5985910b40530a334e662a433";
          hash = "sha256-H5NB6B9yOE7icZ0njuNCFbFko/T4Pmb3IRbOmMq3PzY=";
          fetchSubmodules = true;
        };

        nativeBuildInputs = builtins.attrValues {
          inherit (pkgs) pkg-config gnumake;
        };

        buildInputs = builtins.attrValues {
          inherit (pkgs)
            libsndfile
            cairo
            libX11
            ;
        };

        buildPhase = ''
          runHook preBuild
          make clap AR=gcc-ar RANLIB=gcc-ranlib
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -Dm755 Ratatouille/Ratatouille.clap "$out/lib/clap/Ratatouille.clap"
          runHook postInstall
        '';
      };
    };
}
