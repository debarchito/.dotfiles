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
        value = "7.67";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-VZSt3epsSvqBSiYjK0JIX0kWLTagxbcEBBk2t0b6WXI=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-XYMeykqf9QCzD6jHU/9Lrx266A3pBq3YePKDP2Sjfhc=";
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
