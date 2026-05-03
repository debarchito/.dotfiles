{
  perSystem =
    { pkgs, ... }:
    {
      packages.ratatouille = pkgs.stdenv.mkDerivation {
        pname = "ratatouille";
        version = "0.9.11-git";

        src = pkgs.fetchgit {
          url = "https://github.com/brummer10/Ratatouille.lv2.git";
          rev = "3dbc4bd96e4fcc770bc24e53c37ed26ce98d7ad3";
          hash = "sha256-1Y7kA2XCMhRR5HKGkCbt5oi0YsWmwn90ldX3sQ6B/8Y=";
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
