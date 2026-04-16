{ lib, inputs, ... }:
{
  flake-file.inputs.waydroid-script.url = lib.mkDefault "github:casualsnek/waydroid_script";

  perSystem =
    { pkgs, system, ... }:
    {
      packages.waydroid-script = pkgs.writeShellScriptBin "waydroid-script" ''
        exec ${lib.getExe' inputs.waydroid-script.packages.${system}.default "waydroid_script"} "$@"
      '';
    };
}
