{
  perSystem =
    { pkgs, ... }:
    {
      packages.neuralrack = pkgs.stdenv.mkDerivation rec {
        pname = "neuralrack";
        version = "0.3.3";

        src = pkgs.fetchFromGitHub {
          owner = "brummer10";
          repo = "NeuralRack";
          tag = "v${version}";
          hash = "sha256-N1U3ekTAZqu+aQE/WIL3RHxDQGSxDecFKak5KScioCY=";
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
          install -Dm755 NeuralRack/NeuralRack.clap "$out/lib/clap/NeuralRack.clap"
          runHook postInstall
        '';
      };
    };
}
