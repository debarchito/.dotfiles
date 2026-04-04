{
  perSystem =
    { pkgs, ... }:
    {
      packages.qt6ct = pkgs.qt6Packages.qt6ct.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ../../patches/qt6ct.patch
        ];
      });
    };
}
