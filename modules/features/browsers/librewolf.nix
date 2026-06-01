{ lib, inputs, ... }:
{
  flake-file.inputs.nur = {
    url = lib.mkDefault "github:nix-community/NUR";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.homeManager.options-browsers =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.browsers.librewolf.enable {
        nixpkgs.overlays = [
          inputs.nur.overlays.default
        ];

        programs.librewolf = {
          enable = true;
          nativeMessagingHosts = builtins.attrValues {
            inherit (pkgs)
              pywalfox-native
              tridactyl-native
              ;
          };
          profiles.default = {
            isDefault = true;
            search = {
              default = "DuckDuckGo NoAI";
              engines = {
                "AUR" = {
                  definedAliases = [ "@aur" ];
                  icon = "https://wiki.archlinux.org/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                  urls = [
                    {
                      template = "https://aur.archlinux.org/packages?K={searchTerms}";
                    }
                  ];
                };
                "Arch Wiki" = {
                  definedAliases = [ "@aw" ];
                  icon = "https://wiki.archlinux.org/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                  urls = [ { template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; } ];
                };
                "DuckDuckGo NoAI" = {
                  definedAliases = [ "@ddgna" ];
                  icon = "https://noai.duckduckgo.com/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                  urls = [ { template = "https://noai.duckduckgo.com/?q={searchTerms}"; } ];
                };
                "Nix Search" = {
                  definedAliases = [ "@ns" ];
                  icon = "https://nixsearch.thekoppe.com/apple-touch-icon.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  urls = [
                    {
                      template = "https://nixsearch.thekoppe.com/?q={searchTerms}";
                    }
                  ];
                };
                "NixOS Wiki" = {
                  definedAliases = [ "@nw" ];
                  icon = "https://wiki.nixos.org/nixos.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                };
                "Noogλe" = {
                  definedAliases = [ "@noo" ];
                  icon = "https://wiki.nixos.org/nixos.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  urls = [
                    {
                      template = "https://noogle.dev/q?term={searchTerms}";
                    }
                  ];
                };
              };
              force = true;
            };
            extensions = {
              packages = builtins.attrValues {
                inherit (pkgs.nur.repos.rycee.firefox-addons)
                  bitwarden
                  canvasblocker
                  darkreader
                  fastforwardteam
                  pywalfox
                  tridactyl
                  ublock-origin
                  user-agent-string-switcher
                  violentmonkey
                  ;
              };
              force = true;
            };
            containers = {
              "Personal" = {
                id = 1;
                color = "purple";
                icon = "fingerprint";
              };
              "College" = {
                id = 2;
                color = "orange";
                icon = "fence";
              };
              "Social Media" = {
                id = 3;
                color = "yellow";
                icon = "circle";
              };
            };
            containersForce = true;
            bookmarks = {
              force = true;
              settings = [
                {
                  name = "Cobalt Tools";
                  url = "https://cobalt.tools";
                }
                {
                  name = "redlib.";
                  url = "https://redlib.tiekoetter.com";
                }
                {
                  name = "Nitter";
                  url = "https://nitter.tiekoetter.com";
                }
                {
                  name = "Invidious";
                  url = "https://invidious.tiekoetter.com";
                }
                {
                  name = "Nix Channel Status";
                  url = "https://status.nixos.org";
                }
                {
                  name = "GitHub";
                  url = "https://github.com/debarchito";
                }
                {
                  name = "Codeberg";
                  url = "https://codeberg.org/debarchito";
                }
                {
                  name = "CryptPad";
                  url = "https://crypt.unredacted.org";
                }
                {
                  name = "Board";
                  url = "https://board.unredacted.org";
                }
                {
                  name = "PasteBin";
                  url = "https://paste.unredacted.org";
                }
                {
                  name = "Jitsi";
                  url = "https://jitsi.unredacted.org";
                }
                {
                  name = "Share";
                  url = "https://share.unredacted.org";
                }
                {
                  name = "Nixpkgs Pull Request Tracker";
                  url = "https://nixpk.gs/pr-tracker.html";
                }
              ];
            };
            settings = {
              "places.history.enabled" = false;
              "general.autoScroll" = true;
              "middlemouse.paste" = false;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "svg.context-properties.content.enabled" = true;
              "sidebar.position_start" = true;
              "parfait.animations.enabled" = true;
              "parfait.blur.enabled" = false;
              "parfait.bg.accent-color" = false;
              "parfait.bg.contrast" = 2;
              "parfait.bg.gradient" = false;
              "parfait.bg.opacity" = 4;
              "parfait.bg.transparent" = false;
              "parfait.tabs.groups.color" = false;
              "parfait.sidebar.width.preset" = 2;
              "parfait.theme.lwt.alt" = false;
              "parfait.theme.roundness.preset" = 1;
              "parfait.toolbar.sidebar-gutter" = true;
              "parfait.toolbar.unified-sidebar" = true;
              "parfait.traffic-lights.enabled" = false;
              "parfait.traffic-lights.mono" = false;
              "parfait.urlbar.url.center" = false;
              "parfait.urlbar.results.compact" = false;
              "parfait.urlbar.search-mode.glow" = true;
              "parfait.window.borderless" = false;
              "parfait.new-tab.logo" = 1;
              "parfait.new-tab.bg.pattern" = false;
            };
          };
        };

        home.file.".librewolf/default/chrome".source = pkgs.fetchFromGitHub {
          owner = "debarchito";
          repo = "parfait";
          rev = "2b9055cce370f93b508a2d1e6797708ebb7b59f8";
          hash = "sha256-kXKebHw7UrtP7bXw9uk3IfFZTdjfd2RR5WrXGjJnmig=";
        };

        xdg.configFile."tridactyl/tridactylrc".source = ./librewolf/extensions/tridactyl/tridactylrc;
      };
    };
}
