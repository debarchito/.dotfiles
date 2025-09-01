{
  lib,
  pkgs,
  config,
  ...
}:

{
  options.podman.enable = lib.mkEnableOption "enable podman module";

  config = lib.mkIf config.podman.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    environment.systemPackages = [
      pkgs.crun
    ];
  };
}
