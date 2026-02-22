{
  perSystem =
    { pkgs, ... }:
    {
      packages.blender = pkgs.blender.override {
        cudaSupport = true;
      };
    };
}
