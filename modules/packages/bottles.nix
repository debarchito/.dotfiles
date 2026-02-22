{
  perSystem =
    { pkgs, ... }:
    {
      packages.bottles = pkgs.bottles.override {
        removeWarningPopup = true;
      };
    };
}
