{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "0.10.7.1";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          hash = "sha256-+vmxXcg8TkR/GAiHKnjq4b04bGtQzErfJkOb4P4nZUk=";
        };
        "aarch64-linux" = {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64.AppImage";
          hash = "sha256-ZE7AI7rh68/ogjO+MpUmF0Gc0n/6THnnloR2kFj7HeY=";
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
