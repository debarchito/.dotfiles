{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "2.92";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/Xpl0itU/WiiUDownloader/releases/download/v${version}/WiiUDownloader-Linux-x86_64.AppImage";
          hash = "sha256-YZ6Mm++0n2AQbZ418WRpNQhUel1+kzMjDOB5KA3FXwo=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        wiiudownloader =
          let
            src = pkgs.fetchurl {
              inherit (sources.${system}) url hash;
            };
            appimageContents = pkgs.appimageTools.extractType2 {
              pname = "WiiUDownloader";
              inherit version src;
            };
          in
          pkgs.appimageTools.wrapType2 {
            pname = "WiiUDownloader";
            inherit version src;
            extraInstallCommands =
              # bash
              ''
                export INSTALL='${lib.getExe' pkgs.coreutils "install"}'

                "$INSTALL" -m 444 -D ${appimageContents}/WiiUDownloader.desktop $out/share/applications/WiiUDownloader.desktop
                "$INSTALL" -m 444 -D ${appimageContents}/WiiUDownloader.png $out/share/icons/hicolor/512x512/apps/WiiUDownloader.png

                substituteInPlace $out/share/applications/WiiUDownloader.desktop \
                  --replace 'Exec=AppRun' 'Exec=WiiUDownloader'
              '';
          };
      };
    };
}
