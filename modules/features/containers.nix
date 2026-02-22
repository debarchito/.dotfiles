{
  flake.modules.nixos.options-containers' =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.containers' = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "enable containers, podman and its docker compatibility shim";
            autoPrune = {
              enable = lib.mkEnableOption "allow podman to auto prune resources";
              dates = lib.mkOption {
                type = lib.types.str;
                default = "weekly";
                description = "how often to allow podman to auto prune resources";
              };
              flags = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "flags to pass to the podman prune command";
              };
            };
          };
        };
        default = { };
      };

      config = lib.mkIf config.containers'.enable {
        virtualisation = {
          containers.enable = true;
          podman = {
            enable = true;
            dockerCompat = true;
            dockerSocket.enable = true;
            inherit (config.containers') autoPrune;
          };
        };

        environment.systemPackages = [
          pkgs.podman-compose
        ];
      };
    };
}
