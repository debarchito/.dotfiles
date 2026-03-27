{ lib, inputs, ... }:
{
  flake-file.inputs.waydroid-script.url = lib.mkDefault "github:casualsnek/waydroid_script";

  perSystem =
    { pkgs, system, ... }:
    {
      packages.waydroid-script = pkgs.writeShellScriptBin "waydroid-script" ''
        exec ${inputs.waydroid-script.packages.${system}.default}/bin/waydroid_script "$@"
      '';
    };
}
