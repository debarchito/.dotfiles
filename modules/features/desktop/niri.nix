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

        services.gvfs = {
          enable = true;
          package = pkgs.gnome.gvfs;
        };

        environment.systemPackages = builtins.attrValues {
          inherit (pkgs) nautilus xwayland-satellite;
        };
      };
    };

  flake.modules.homeManager.options-desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
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
          gtk3.theme = {
            name = "adw-gtk3";
            package = pkgs.adw-gtk3;
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

        home = {
          packages = builtins.attrValues {
            inherit (pkgs)
              corefonts
              lora
              noto-fonts-cjk-sans
              noto-fonts-cjk-serif
              papirus-folders
              poppins
              pywalfox-native
              qt6ct
              vista-fonts
              wlr-which-key
              ;
            inherit (pkgs.maple-mono) NF;
            inherit (pkgs.kdePackages) breeze;
            inherit (pkgs.libsForQt5) qt5ct;
          };
          activation.poppins-install =
            lib.hm.dag.entryAfter [ "writeBoundary" ]
              # bash
              ''
                ICON_DIR="$HOME/.local/share/icons"
                REPO_URL='https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git'
                REPO_REV='b03ccf6ac078ca8242c1d22d00a0f419b26d84e4'
                GIT='${lib.getExe pkgs.git}'

                if [ -d "$ICON_DIR/Papirus" ]; then
                  echo "[?] Papirus icon theme already exists at: $ICON_DIR/Papirus. Skipping."
                else
                  echo '[-*-] Fetching and installing Papirus icon theme...'

                  mkdir -p "$ICON_DIR"

                  TMP_DIR=$(mktemp -d)
                  trap 'rm -rf "$TMP_DIR"' EXIT

                  "$GIT" -c advice.detachedHead=false clone \
                    --revision="$REPO_REV" \
                    --depth=1 \
                    --filter=blob:none \
                    --sparse "$REPO_URL" "$TMP_DIR"
                  "$GIT" -C "$TMP_DIR" sparse-checkout set Papirus

                  cp -r "$TMP_DIR/Papirus" "$ICON_DIR/Papirus"

                  echo "[+] Successfully installed Papirus icon theme."
                fi
              '';
        };
      };
    };
}
