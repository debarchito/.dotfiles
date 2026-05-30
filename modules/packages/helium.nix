{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "0.12.5.1";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          hash = "sha256-uUZauNralX6katmnO9VDLEs+d+HIhkjkeV36Dw2eUmM=";
        };
        "aarch64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
          hash = "sha256-OC3uPbQcykuTx13v4hnTSOWCV3g75+0wkCMbT4dwkIg=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        helium =
          let
            src = pkgs.fetchurl {
              inherit (sources.${system}) url hash;
            };
            appimageContents = pkgs.appimageTools.extractType2 {
              pname = "helium";
              inherit version src;
            };
          in
          pkgs.appimageTools.wrapType2 {
            pname = "helium";
            inherit version src;
            extraInstallCommands =
              # bash
              ''
                export INSTALL='${lib.getExe' pkgs.coreutils "install"}'

                "$INSTALL" -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
                "$INSTALL" -m 444 -D ${appimageContents}/helium.png $out/share/icons/hicolor/512x512/apps/helium.png

                substituteInPlace $out/share/applications/helium.desktop \
                  --replace 'Exec=AppRun' 'Exec=helium'
              '';
          };
      };
    };
}
