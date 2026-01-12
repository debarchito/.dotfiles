{
  lib,
  pkgs,
  config,
  ...
}:

{
  options = {
    podman.enable = lib.mkEnableOption "enable podman module";
    podman.settings = lib.mkOption { description = "podman related settings"; };
  };

  config = lib.mkIf config.podman.enable {
    virtualisation.containers.enable = true;

    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;
    virtualisation.podman.dockerSocket.enable = true;
    virtualisation.podman.defaultNetwork.settings = config.podman.settings;

    environment.systemPackages = [
      pkgs.crun
    ];
  };
}
