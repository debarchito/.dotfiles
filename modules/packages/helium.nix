{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "0.10.5.1";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          hash = "sha256-c/ea8C1XjTkBo0/ujGHEbKWyCmRMxyuiuOzAO9AMf1o=";
        };
        "aarch64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
          hash = "sha256-7h0Uvn937RxYol7a50FWHC8n1VEgKy+EHdCAivsMEUo=";
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
                ${pkgs.coreutils}/bin/install -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
                ${pkgs.coreutils}/bin/install -m 444 -D ${appimageContents}/helium.png $out/share/icons/hicolor/512x512/apps/helium.png

                substituteInPlace $out/share/applications/helium.desktop \
                  --replace 'Exec=AppRun' 'Exec=helium'
              '';
          };
      };
    };
}
