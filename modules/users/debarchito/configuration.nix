{
  lib,
  self,
  inputs,
  withSystem,
  moduleWithSystem,
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
        "wheel"
        "networkmanager"
        "libvirtd"
        "kvm"
        "audio"
      ];
    };

    common.flake = "/home/${username}/.dotfiles";

    networking' = {
      allowPortRanges = [
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

    qemu = {
      enable = true;
      runAsRoot = true;
      manager.enable = true;
    };

    desktop = {
      niri.enable = true;
      labwc.nested.enable = true;
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
        self.modules.homeManager."users-${username}"
        {
          home.stateVersion = "24.11";

          nixpkgs.config.allowUnfree = true;
        }
      ];
    }
  );

  flake.modules.homeManager."users-${username}" = moduleWithSystem (
    { self', ... }:
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        inputs.nix-alien.overlays.default
      ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };

      desktop.niri.dms.enable = true;

      terminal.common.enable = true;

      browsers.librewolf.enable = true;

      editors.zed-editor.enable = true;

      media.daw.enable = true;

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
          enable = true;
          settings = {
            command = "fish";
            shell-integration = "fish";
            window-decoration = "none";
            window-padding-x = 10;
            window-padding-y = "0,0";
            font-family = "Maple Mono NF";
            font-size = 15;
            font-feature = "-calt,-zero,-cv02,+cv01,+cv61";
            config-file = "./themes/dankcolors";
            app-notifications = "no-clipboard-copy,no-config-reload";
          };
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

        mpv.enable = true;

        nix-search-tv.enable = true;

        obs-studio = {
          enable = true;
          package = self'.packages.obs-studio;
          plugins = [
            pkgs.obs-studio-plugins.obs-pipewire-audio-capture
            pkgs.obs-studio-plugins.obs-vkcapture
          ];
        };

        rbw = {
          enable = true;
          settings = {
            email = "debarchitonath@gmail.com";
            pinentry = pkgs.pinentry-qt;
          };
        };

        vesktop.enable = true;

        zathura.enable = true;
      };

      services = {
        easyeffects.enable = true;

        kdeconnect.enable = true;
      };

      home.packages = [
        pkgs.aseprite
        self'.packages.blender
        pkgs.bibata-cursors
        self'.packages.bottles
        pkgs.duckdb
        pkgs.ffmpeg
        pkgs.gearlever
        pkgs.krita
        pkgs.kdePackages.dolphin
        pkgs.kdePackages.gwenview
        pkgs.kdePackages.okular
        pkgs.nix-alien
        pkgs.nix-output-monitor
        pkgs.pear-desktop
        pkgs.qbittorrent
        pkgs.wl-mirror
        pkgs.wl-clipboard
      ];
    }
  );
}
