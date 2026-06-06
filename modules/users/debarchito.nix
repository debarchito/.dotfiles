{
  lib,
  self,
  inputs,
  withSystem,
  ...
}:
let
  username = "debarchito";
  description = "Debarchito Nath";
in
{
  flake-file.inputs.nix-alien = {
    url = lib.mkDefault "github:thiagokokada/nix-alien";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.nixos."users-${username}" = {
    users.users.${username} = {
      isNormalUser = true;
      inherit description;
      extraGroups = [
        "adbusers"
        "audio"
        "kvm"
        "libvirtd"
        "networkmanager"
        "wheel"
        "wireshark"
      ];
    };

    common.flake = "/home/${username}/.dotfiles";

    networking' = {
      allowedPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      openssh = {
        enable = true;
        ports = [ 54321 ];
        endlessh.port = 22;
        settings.AllowUsers = [ username ];
      };
      openvpn.enable = true;
      wireshark.enable = true;
    };

    media = {
      routing.enable = true;
      bluetooth.enable = true;
      optimizations.enable = true;
      streaming.server = {
        enable = true;
        autostart = false;
      };
    };
    hardware.bluetooth.settings.Policy.AutoEnable = false;

    containers'.enable = true;
    virtualisation = {
      containers.storage.settings = {
        storage.driver = "btrfs";
      };
      podman.defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    virtualisation' = {
      qemu = {
        enable = true;
        runAsRoot = true;
        manager.enable = true;
      };
      waydroid.enable = true;
    };

    desktop = {
      niri.enable = true;
      labwc.enable = true;
    };

    packaging = {
      flatpak.enable = true;
      appimage.enable = true;
    };

    gaming = {
      steam.enable = true;
      gamescope.enable = true;
      gamemode.enable = true;
    };
  };

  flake.homeConfigurations."${username}@dell-laptop" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        self.modules.homeManager.options-desktop
        self.modules.homeManager.options-terminal
        self.modules.homeManager.options-browsers
        self.modules.homeManager.options-editors
        self.modules.homeManager.options-media
        self.modules.homeManager.options-gaming
        self.modules.homeManager.options-packaging
        self.modules.homeManager."users-${username}"
        {
          home.stateVersion = "24.11";

          nixpkgs.config.allowUnfree = true;
        }
      ];
    }
  );

  flake.modules.homeManager."users-${username}" =
    { pkgs, lib, ... }:
    let
      wrapKDEMenuPrefix =
        pkg:
        pkgs.symlinkJoin {
          name = "${pkg.name}-wrapped";
          paths = [ pkg ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/${pkg.pname} \
              --set XDG_MENU_PREFIX "plasma-"
          '';
        };
    in
    {
      nixpkgs.overlays = [
        inputs.nix-alien.overlays.default
      ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        packages =
          builtins.attrValues {
            inherit (pkgs)
              android-tools
              aseprite
              bibata-cursors
              blender
              bottles
              duckdb
              ffmpeg
              generate
              krita
              libqalculate
              libreoffice-qt-fresh
              nix-alien
              nix-output-monitor
              nix-prefetch-github
              numbat
              pear-desktop
              pika-backup
              proton-vpn
              qbittorrent
              scrcpy
              trash-cli
              wl-mirror
              ;
          }
          ++ (map wrapKDEMenuPrefix (
            builtins.attrValues {
              inherit (pkgs.kdePackages)
                dolphin
                gwenview
                okular
                ark
                ;
            }
          ));
        file.".julia/config/startup.jl".source = ../scripts/julia/startup.jl;
        activation.plasma-application-menu = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          XDG_MENU_PREFIX=plasma- ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental
        '';
      };

      xdg.configFile."menus/plasma-applications.menu".source =
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

      desktop = {
        niri = {
          enable = true;
          dms.enable = true;
        };
        # labwc.dms.enable = true;
      };

      terminal.common.enable = true;

      browsers = {
        helium.enable = true;
        librewolf.enable = true;
      };

      editors = {
        # doom-emacs.enable = true;
        zed-editor.enable = true;
      };

      media.daw.enable = true;

      packaging.flatpak.enableEssentials = true;

      programs = {
        distrobox.enable = true;

        # terminal.common.enable -> git.enable
        git = {
          settings = {
            user = {
              name = "Debarchito Nath";
              email = "debarchiton@proton.me";
            };
            url = {
              "git@github.com:".insteadOf = "gh:";
              "git@gitlab.com:".insteadOf = "gl:";
              "git@codeberg.org:".insteadOf = "cb:";
              "git@github.com:debarchito/".insteadOf = "me@gh:";
              "git@codeberg.org:debarchito/".insteadOf = "me@cb:";
            };
          };
          signing = {
            format = "ssh";
            signByDefault = true;
            key = "~/.ssh/id_ed25519.pub";
          };
        };

        ghostty = {
          enable = false;
          settings = {
            command = "fish";
            shell-integration = "fish";
            window-decoration = "none";
            window-padding-x = 10;
            window-padding-y = "0,0";
            font-family = "Maple Mono NF";
            font-size = 14;
            font-feature = "-calt,-zero,-cv02,+cv01,+cv61";
            config-file = "./themes/dankcolors";
            app-notifications = "no-clipboard-copy,no-config-reload";
          };
        };

        kitty = {
          enable = true;
          settings = {
            shell = "fish";
            shell_integration = "enabled";
            hide_window_decorations = "yes";
            window_padding_width = 10;
            placement_strategy = "center";
            resize_in_steps = "yes";
            font_family = "Maple Mono NF";
            font_size = 14;
            font_features = "MapleMonoNF-Regular -calt -zero -cv02 +cv01 +cv61";
            text_composition_strategy = "legacy";
            notify_on_select = "no";
          };
          extraConfig =
            # conf
            ''
              include themes/dankcolors.conf
            '';
        };

        # terminal.common.enable -> helix.enable
        helix.defaultEditor = true;

        home-manager.enable = true;

        # terminal.common.enable -> jujutsu.enable
        jujutsu.settings = {
          user = {
            name = "Debarchito Nath";
            email = "debarchiton@proton.me";
          };
          signing = {
            backend = "ssh";
            behavior = "own";
            key = "~/.ssh/id_ed25519.pub";
          };
        };

        mpv = {
          enable = true;
          scripts = builtins.attrValues {
            inherit (pkgs.mpvScripts.builtins)
              autoload
              ;
            inherit (pkgs.mpvScripts)
              sponsorblock
              thumbfast
              uosc
              ;
            inherit (pkgs.mpvScripts.eisa01)
              simplebookmark
              simplehistory
              ;
          };
        };

        nushell.enable = true;

        nix-search-tv.enable = true;

        obs-studio = {
          enable = true;
          plugins = [
            pkgs.obs-studio-plugins.obs-pipewire-audio-capture
            pkgs.obs-studio-plugins.obs-vkcapture
          ];
        };

        rbw = {
          enable = true;
          settings = {
            email = "debarchitonath@gmail.com";
            pinentry = pkgs.pinentry-dms;
          };
        };

        thunderbird.enable = true;

        vesktop.enable = true;
      };

      services = {
        easyeffects.enable = true;

        kdeconnect.enable = true;
      };

      gaming = {
        games = {
          minecraft.enable = true;
          genshin-impact.enable = true;
          honkai-star-rail.enable = true;
        };
        emulators = {
          wiiu.enable = true;
          switch.enable = true;
        };
      };
    };
}
