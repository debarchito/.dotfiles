{ inputs, lib, ... }:
{
  flake-file.inputs = {
    dms = {
      url = lib.mkDefault "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dsearch = {
      url = lib.mkDefault "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    quickshell = {
      url = lib.mkDefault "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

  flake.modules.homeManager.options-desktop =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.dms.homeModules.niri
        inputs.dms.homeModules.dank-material-shell
        inputs.dsearch.homeModules.default
      ];

      config =
        let
          dankPlugins = {
            calculator = {
              rev = "73073d051d08254633f28f89d2609344c8289813";
              hash = "sha256-hiqrO8WkzmWGVlUrzxmffUZBs4t1QM2mMTBUxZqCIyU=";
            };
            clipboardPlus = {
              rev = "46405816d7e69af59026d10447c93262c645296c";
              hash = "sha256-7B7zyzOQ4vjWjyZv8dAHy+ViT3SjsbcLMO1Y9NFvHxs=";
            };
            commandRunner = {
              rev = "35277695de06beadaba701cb94cc8b096b233319";
              hash = "sha256-o43IyVT901ZzZGDvZKWhlrgMba57thAoqL3+BFaFV74=";
            };
            dockerManager = {
              rev = "860457bbb043a6651a2cbafe6e77d443123a0b07";
              hash = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
            };
            dankBitwarden = {
              rev = "6fd83d8b6ab54d2d6a996bed7291b70316c99965";
              hash = "sha256-ukcJy4ecyOiqSm9FO87hsq8BZ37EQVuduhDfoDw0LE4=";
            };
            emojiLauncher = {
              rev = "1c0a7d337a52b48f9499060076703a35e8dd4f4f";
              hash = "sha256-NQ14YenDiNK2VqXQ3z7jAkatbSRtYJHhOhvv7AJlUD8=";
            };
            niriWindows = {
              rev = "b866af4cb599e7eeae90779b959f56b1a9905f18";
              hash = "sha256-KkB+xq4AObTqTDxtBVqfCsnxn0jnNk3iM4vpk9jlEBA=";
            };
            webSearch = {
              rev = "8ec42a2dff96b94cdd0d40b57c1acd815c15079a";
              hash = "sha256-S1A50s7cKE0NuidC+x589wIxqGA6JW8GrCVEkCddMQs=";
            };
          };

          officialDMSRepository = pkgs.fetchFromGitHub {
            owner = "debarchito";
            repo = "dms-plugins";
            rev = "f4583449f12920e0a2f16808b00a860c27f0173d";
            hash = "sha256-QkQPqP7Wmo5DLRyKNSY5NuOau4LSaSfz3DYdHDLxluA=";
          };

          officialDMSPlugins = [
            "DankHooks"
            "DankKDEConnect"
            "DankNotepadModule"
          ];

          dankPinentryRepository = pkgs.fetchFromGitHub {
            owner = "debarchito";
            repo = "dankPinentry";
            rev = "02df8bceb651bdbc5fdc7a07b5f6f19e60c3906a";
            hash = "sha256-TmaRMZEHLatEjV5dIZqgEJMdqcK8CtG5mL++vWVlckg=";
          };

          dankPinentryPlugins = [
            "plugin"
          ];

          dadanDMSPluginsRepository = pkgs.fetchFromGitHub {
            owner = "debarchito";
            repo = "dadan-dms-plugins";
            rev = "cb23b2590038ba47db3f27eca5101a8ac864da7d";
            hash = "sha256-8knIOnc0+LDsgusCzEz3CJBksvVrn3ytDHMfRAPEUhY=";
          };

          dadanDMSPlugins = [
            "ClipboardPlus"
          ];
        in
        lib.mkIf (config.desktop.niri.enable && config.desktop.niri.dms.enable) {
          nixpkgs.overlays = [
            inputs.quickshell.overlays.default
          ];

          programs = {
            dank-material-shell = {
              enable = true;
              quickshell.package = pkgs.quickshell;
              niri.includes.enable = false;
              plugins =
                (lib.mapAttrs (name: value: {
                  src = pkgs.fetchFromGitHub {
                    owner = "debarchito";
                    repo = name;
                    inherit (value) rev hash;
                  };
                }) dankPlugins)
                // (lib.genAttrs officialDMSPlugins (name: {
                  src = "${officialDMSRepository}/${name}";
                }))
                // (lib.genAttrs dankPinentryPlugins (name: {
                  src = "${dankPinentryRepository}/${name}";
                }))
                // (lib.genAttrs dadanDMSPlugins (name: {
                  src = "${dadanDMSPluginsRepository}/${name}";
                }));
            };
            dsearch.enable = true;
          };

          xdg.configFile =
            let
              vars.USERNAME = config.home.username;
            in
            {
              "DankMaterialShell/settings.json".source = ./dank-material-shell/settings.json;
              "DankMaterialShell/plugin_settings.json".source =
                pkgs.replaceVars ./dank-material-shell/plugin_settings.json vars;
            };
        };
    };
}
