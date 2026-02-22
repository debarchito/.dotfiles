{
  perSystem =
    { pkgs, ... }:
    {
      packages.obs-studio = pkgs.obs-studio.override {
        cudaSupport = true;
      };
    };
}
