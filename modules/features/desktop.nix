{
  lib,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs = {
    niri = {
      url = lib.mkDefault "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dms = {
      url = lib.mkDefault "github:AvengeMedia/DankMaterialShell";
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

  flake.modules.homeManager.options-desktop = moduleWithSystem (
    { self', ... }:
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      dankPlugins = {
        commandRunner = {
          rev = "548b7d79aa8967443d44e57293a2e0fe16d65f36";
          hash = "sha256-cF8D6HdNI5b60O07xAoq33howGquTNSQXC/znnaZEys=";
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
          rev = "15d8ea655bbec7854883ea5e9b8b367494a1daf4";
          hash = "sha256-k/Bvhuad5ZmAt29Ts1e57pJgzNESFwGhLCnaoo31R9w=";
        };
        niriWindows = {
          rev = "b866af4cb599e7eeae90779b959f56b1a9905f18";
          hash = "sha256-KkB+xq4AObTqTDxtBVqfCsnxn0jnNk3iM4vpk9jlEBA=";
        };
        webSearch = {
          rev = "34dc01f2d3eabcc7f6e6bc2908f64be787d396c5";
          hash = "sha256-w+5rEpjYRyMA/gX98Ejyl2IFpLRO7QszbZHLibjT5S4=";
        };
      };

      officialDankRepository = pkgs.fetchFromGitHub {
        owner = "debarchito";
        repo = "dms-plugins";
        rev = "0de003833c3677abd1c80bd3e200a59756b51590";
        hash = "sha256-t5aqLWTqCW6BGhqmJpQ5MtQVEiUo0lktiTwxEJ3w1mE=";
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
        programs = {
          niri.config = null;
          dank-material-shell = {
            enable = true;
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
            niri = ./desktop/niri;
            dank-material-shell = "${niri}/dank-material-shell";
            vars = {
              USERNAME = config.home.username;
            };
          in
          {
            "niri/config.kdl".source = "${niri}/config.kdl";
            "DankMaterialShell/settings.json".source = "${dank-material-shell}/settings.json";
            "DankMaterialShell/plugin_settings.json".source =
              pkgs.replaceVars "${dank-material-shell}/plugin_settings.json" vars;
            "matugen/templates".source = "${dank-material-shell}/matugen/templates";
            "matugen/config.toml".source = pkgs.replaceVars "${dank-material-shell}/matugen/config.toml" vars;
            "qt5ct/qt5ct.conf".source = pkgs.replaceVars "${niri}/qt5ct/qt5ct.conf" vars;
            "qt6ct/qt6ct.conf".source = pkgs.replaceVars "${niri}/qt6ct/qt6ct.conf" vars;
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
        };

        qt = {
          enable = true;
          platformTheme = {
            name = "qtct";
            package = self'.packages.qt6ct;
          };
        };

        home.packages = [
          pkgs.lora
          pkgs.poppins
          pkgs.maple-mono.NF
          pkgs.noto-fonts-cjk-sans
          self'.packages.papirus-folders
          pkgs.kdePackages.breeze
          pkgs.libsForQt5.qt5ct
          self'.packages.qt6ct
          pkgs.pywal
          pkgs.pywalfox-native
        ];
      };
    }
  );
}
