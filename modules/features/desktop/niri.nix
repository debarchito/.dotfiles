{ inputs, lib, ... }:
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
    xwayland-satellite = {
      url = lib.mkDefault "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

  flake.modules.nixos.options-desktop =
    { config, pkgs, ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];

      config = lib.mkIf config.desktop.niri.enable {
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
      };
    };

  flake.modules.homeManager.options-desktop =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.niri.homeModules.config
      ];

      config = lib.mkIf config.desktop.niri.enable {
        nixpkgs.overlays = [
          inputs.niri.overlays.niri
          inputs.quickshell.overlays.default
        ];

        programs.niri = {
          package = pkgs.niri-unstable;
          # NOTE: Inlining is fine since the dank-material-shell is the only niri config i've rn
          config = builtins.readFile ./dank-material-shell/niri/config.kdl;
        };

        xdg.configFile =
          let
            vars.USERNAME = config.home.username;
          in
          {
            # TODO: Make matugen independent of dank-material-shell at some point
            "matugen".source = ./dank-material-shell/matugen;
            "qt5ct/qt5ct.conf".source = pkgs.replaceVars ./qt5ct/qt5ct.conf vars;
            "qt6ct/qt6ct.conf".source = pkgs.replaceVars ./qt6ct/qt6ct.conf vars;
          };

        fonts.fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [
              "Lora"
              "Noto Serif CJK JP"
              "Noto Serif CJK SC"
              "Noto Serif CJK TC"
              "Noto Serif CJK HK"
              "Noto Serif CJK KR"
            ];
            sansSerif = [
              "Poppins"
              "Noto Sans CJK JP"
              "Noto Sans CJK SC"
              "Noto Sans CJK TC"
              "Noto Sans CJK HK"
              "Noto Sans CJK KR"
            ];
            monospace = [
              "Maple Mono NF"
              "Noto Sans Mono CJK JP"
              "Noto Sans Mono CJK SC"
              "Noto Sans Mono CJK TC"
              "Noto Sans Mono CJK HK"
              "Noto Sans Mono CJK KR"
            ];
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
            noto-fonts-cjk-serif
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
