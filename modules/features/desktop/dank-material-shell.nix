{ inputs, lib, ... }:
{
  flake-file.inputs = {
    dms = {
      url = lib.mkDefault "github:AvengeMedia/DankMaterialShell";
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
      ];

      config =
        let
          dankPlugins = {
            calculator = {
              rev = "07d7c123a5aee9ac4fd4347bbae36d5957b021f9";
              hash = "sha256-bhV22bL38CJp58Y8tCY8sEBRYxmuk671fEymmdg0Yuk=";
            };
            clipboardPlus = {
              rev = "9ec2e2a882c35cb1fa50790f028fd24424492475";
              hash = "sha256-yfM/jMN/sjw9i6tMlKRWYnClUc4CCRww/Mh2g/TpYAo=";
            };
            commandRunner = {
              rev = "5e640d23dfdff291ee061b854fa4ee74b1984bf9";
              hash = "sha256-l1LavTNDwAoQn4I+P6DfAsaz4nd5ngEbCaoHVQ47cWs=";
            };
            displayMirror = {
              rev = "92cd44c4fb67834bf71fdd78f83c29df5e0750b2";
              hash = "sha256-JX3pDZ1F5Uu/rOdA4KMhcwH8a6gxsTZjwgcZxNV/Ngc=";
            };
            dockerManager = {
              rev = "860457bbb043a6651a2cbafe6e77d443123a0b07";
              hash = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
            };
            dankBitwarden = {
              rev = "88834a3a2a2b1f853fd6efa989ed2f2aee58cab5";
              hash = "sha256-FKmMTqUCR/Rl/WJT9Q/+q8IsNPIDW+7ZJSX0zmkrs18=";
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
            screenRecorder = {
              rev = "7206b590d69a165d30b5bbb66b033f1a15b49aff";
              hash = "sha256-ndH8KHH+gzFIXWceqeUmy/w7oGj7ZvCEIacBfV1D+KU=";
            };
          };

          officialDankRepository = pkgs.fetchFromGitHub {
            owner = "debarchito";
            repo = "dms-plugins";
            rev = "829922a8f11949b1c13ae8bd14d7176f9165b6f5";
            hash = "sha256-KYx+n1stxLT4R9IDVRx3/Cl7TjCcBZjnQchbrXaBT2o=";
          };

          officialDankPlugins = [
            "DankHooks"
            "DankKDEConnect"
            "DankNotepadModule"
          ];
        in
        lib.mkIf (config.desktop.niri.enable && config.desktop.niri.dms.enable) {
          nixpkgs.overlays = [
            inputs.quickshell.overlays.default
          ];

          programs.dank-material-shell = {
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
              // (lib.genAttrs officialDankPlugins (name: {
                src = "${officialDankRepository}/${name}";
              }));
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
