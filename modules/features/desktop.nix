{ lib, inputs, ... }:
{
  flake-file.inputs = {
    niri-source = {
      url = lib.mkDefault "github:niri-wm/niri";
      flake = false;
    };
    niri = {
      url = lib.mkDefault "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
      inputs.niri-unstable.follows = lib.mkDefault "niri-source";
    };
    dms = {
      url = lib.mkDefault "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    quickshell = {
      url = lib.mkDefault "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    xwayland-satellite = {
      url = lib.mkDefault "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

  flake.modules.nixos.options-desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.niri.nixosModules.niri ];

      options.desktop = lib.mkOption {
        type = lib.types.submodule {
          options = {
            niri.enable = lib.mkEnableOption "enable unstable niri builds";
            labwc.nested.enable = lib.mkEnableOption "enable labwc primarily as a nested compositor";
          };
        };
        default = { };
      };

      config = lib.mkMerge [
        (lib.mkIf config.desktop.niri.enable {
          nixpkgs.overlays = [
            inputs.niri.overlays.niri
            inputs.xwayland-satellite.overlays.default
          ];

          programs.niri = {
            enable = true;
            package = pkgs.niri-unstable;
          };

          environment.systemPackages = [
            pkgs.nautilus
            pkgs.xwayland-satellite
          ];
        })

        (lib.mkIf config.desktop.labwc.nested.enable {
          programs.labwc.enable = true;
        })
      ];
    };

  flake.modules.homeManager.options-desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      dankPlugins = {
        calculator = {
          rev = "07d7c123a5aee9ac4fd4347bbae36d5957b021f9";
          hash = "sha256-bhV22bL38CJp58Y8tCY8sEBRYxmuk671fEymmdg0Yuk=";
        };
        clipboardPlus = {
          rev = "47547af5993d05cca94e64a5f6f0b4c0732f68af";
          hash = "sha256-P3rgWf+I6HaePaJGb5M9860LBRtxVhQC+HKPqUgnqJY=";
        };
        commandRunner = {
          rev = "a6252e8f397eeeb80e10b5a92713118221493dae";
          hash = "sha256-utn8o1p2s/lFL8ObrY3DfGXqOZsuKL+oj6UResKxFLI=";
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
          rev = "cb5a2ae79084f84890135005ed2e60567307e690";
          hash = "sha256-5VpvUbFeatfuGdnUlNa5FB78R4dN1Zw9r/uWpUxHHfU=";
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
        rev = "141841fc85e01494df6d217bd5a27c65da87256d";
        hash = "sha256-/155wFIotV9xiZzX9XRGs3ANjBcLJwS4kNDDNO6WkF0=";
      };

      officialDankPlugins = [
        "DankHooks"
        "DankKDEConnect"
        "DankNotepadModule"
      ];
    in
    {
      imports = [
        inputs.niri.homeModules.config
        inputs.dms.homeModules.niri
        inputs.dms.homeModules.dank-material-shell
      ];

      options.desktop = lib.mkOption {
        type = lib.types.submodule {
          options.niri.dms.enable = lib.mkEnableOption "enable my dank-material-shell setup";
        };
        default = { };
      };

      config = lib.mkIf config.desktop.niri.dms.enable {
        nixpkgs.overlays = [
          inputs.quickshell.overlays.default
        ];

        programs = {
          # Borked till the day "includes" is supported!
          niri.config = null;
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
              // (lib.genAttrs officialDankPlugins (name: {
                src = "${officialDankRepository}/${name}";
              }));
          };
        };

        xdg.configFile =
          let
            dank-material-shell = ./desktop/dank-material-shell;
            vars = {
              USERNAME = config.home.username;
            };
          in
          {
            "niri/config.kdl".source = ./desktop/niri/config.kdl;
            "DankMaterialShell/settings.json".source = "${dank-material-shell}/settings.json";
            "DankMaterialShell/plugin_settings.json".source =
              pkgs.replaceVars "${dank-material-shell}/plugin_settings.json" vars;
            "matugen/templates".source = "${dank-material-shell}/matugen/templates";
            "matugen/config.toml".source = "${dank-material-shell}/matugen/config.toml";
            "qt5ct/qt5ct.conf".source = pkgs.replaceVars ./desktop/qt5ct/qt5ct.conf vars;
            "qt6ct/qt6ct.conf".source = pkgs.replaceVars ./desktop/qt6ct/qt6ct.conf vars;
          };

        fonts.fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [ "Lora" ];
            sansSerif = [ "Poppins" ];
            monospace = [ "Maple Mono NF" ];
          };
        };

        gtk = {
          enable = true;
          font = {
            name = "Poppins";
            size = 10;
          };
          gtk4.theme = config.gtk.theme;
        };

        qt = {
          enable = true;
          platformTheme = {
            name = "qtct";
            package = pkgs.qt6ct;
          };
        };

        home.packages = builtins.attrValues {
          inherit (pkgs)
            lora
            poppins
            noto-fonts-cjk-sans
            wlr-which-key
            pywalfox-native
            papirus-folders
            qt6ct
            ;
          inherit (pkgs.maple-mono) NF;
          inherit (pkgs.kdePackages) breeze;
          inherit (pkgs.libsForQt5) qt5ct;
        };
      };
    };
}
