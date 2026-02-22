{ inputs, lib, ... }:
{
  flake-file.inputs.nix-flatpak.url = lib.mkDefault "github:gmodena/nix-flatpak";

  flake.modules.nixos.options-packaging =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.packaging = lib.mkOption {
        type = lib.types.submodule {
          options = {
            flatpak.enable = lib.mkEnableOption "enable flatpak";
            appimage.enable = lib.mkEnableOption "enable appimage with sane defaults";
          };
        };
        default = { };
      };

      config = lib.mkMerge [
        (lib.mkIf config.packaging.flatpak.enable {
          services.flatpak.enable = true;
        })

        (lib.mkIf config.packaging.appimage.enable {
          programs.appimage.enable = true;
          programs.appimage.binfmt = true;
          programs.appimage.package = pkgs.appimage-run.override {
            extraPkgs = pkgs: [
              pkgs.libxcrypt
              pkgs.icu
            ];
          };
        })
      ];
    };

  flake.modules.homeManager.options-packaging =
    { lib, config, ... }:
    {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];

      options.packaging = lib.mkOption {
        type = lib.types.submodule {
          options.flatpak.enableEssentials = lib.mkEnableOption "enable essential flatpak apps";
        };
        default = { };
      };

      config = lib.mkIf config.packaging.flatpak.enableEssentials {
        services = {
          flatpak = {
            enable = true;
            remotes = lib.mkOptionDefault [
              {
                name = "flathub";
                location = "https://flathub.org/repo/flathub.flatpakrepo";
              }
            ];
            packages = [
              "com.github.tchx84.Flatseal"
              "io.github.flattool.Warehouse"
              "org.gnome.World.PikaBackup"
              # NOTE: I generally use flatpak apps for very specific scenarios where the nixpkgs version doesn't cut it.
            ];
            update.auto.enable = true;
            update.auto.onCalendar = "daily";
          };
        };
      };
    };
}
