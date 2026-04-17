{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "0.11.2.1";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          hash = "sha256-tGOgJSCGrGfkG2aE0VcGm2GH8ttiBQ602GftlWEHRHA=";
        };
        "aarch64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
          hash = "sha256-d7+ABYr/AXtxzetTkDoCZ4zOltaY8GFceLHTQ9qAEFc=";
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
