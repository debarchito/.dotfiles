{
  perSystem =
    { pkgs, ... }:
    {
      packages.neuralrack = pkgs.stdenv.mkDerivation {
        pname = "neuralrack";
        version = "0.3.2";

        src = pkgs.fetchgit {
          url = "https://github.com/brummer10/NeuralRack.git";
          rev = "v0.3.2";
          hash = "sha256-Rk+7mlRQfWQ5f/Wst33kIJW7Ac7KElA9ZHkIA2vCdOg=";
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
          install -Dm755 NeuralRack/NeuralRack.clap "$out/lib/clap/NeuralRack.clap"
          runHook postInstall
        '';
      };
    };
}
