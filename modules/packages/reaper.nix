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
        value = "7.65";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-Qp6xQ1ZIUYx8U6TqzHNh4tTFm0zi9dE0iN/ZK36Y0Ks=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-w+6jig8bs+U8Pb3lVGiuUCAM7fWdkMXdJpyBflZd4EI=";
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
