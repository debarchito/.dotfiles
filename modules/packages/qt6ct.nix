{
  perSystem =
    { pkgs, ... }:
    {
      packages.qt6ct = pkgs.qt6Packages.qt6ct.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ./_patches/qt6ct.patch
        ];
      });
    };
}
