{
  perSystem =
    { pkgs, ... }:
    {
      packages.prismlauncher-unwrapped = pkgs.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ../../patches/prismlauncher-unwrapped.patch
        ];
      });
    };
}
