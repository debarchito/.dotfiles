{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = rec {
        value = "7.70";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-AVfzPrhx3nnXqI7o913YdMELywcREq78z7a+wWb+DMU=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-G7V+stNHEdZZCcV1so57/6qCrKejF7RezGHc7ROwbRc=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        reaper = pkgs.reaper.overrideAttrs (_: {
          version = version.value;
          src = pkgs.fetchurl {
            inherit (sources.${system}) url hash;
          };
        });
      };
    };
}
