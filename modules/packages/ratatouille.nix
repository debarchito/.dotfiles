{
  perSystem =
    { pkgs, ... }:
    {
      packages.ratatouille = pkgs.stdenv.mkDerivation rec {
        pname = "ratatouille";
        version = "0.9.11";

        src = pkgs.fetchFromGitHub {
          owner = "brummer10";
          repo = "Ratatouille.lv2";
          tag = "v${version}";
          hash = "sha256-mig3yUGSNz1xuyz6ljKqJUjNqmEcsbXSH1vTxTGdOFk=";
          fetchSubmodules = true;
        };

        nativeBuildInputs = builtins.attrValues {
          inherit (pkgs)
            pkg-config
            gnumake
            ;
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
