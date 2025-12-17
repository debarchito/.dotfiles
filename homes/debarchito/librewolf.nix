{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
      pkgs.tridactyl-native
    ];
    profiles.default = {
      isDefault = true;
      search.engines = {
        "NixOS Search - Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";
            }
          ];
          icon = "https://wiki.nixos.org/nixos.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@np" ];
        };
        "NixOS Search - Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";
            }
          ];
          icon = "https://wiki.nixos.org/nixos.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@no" ];
        };
        "Home Manager - Option Search" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
            }
          ];
          icon = "https://home-manager-options.extranix.com/images/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@ho" ];
        };
        "NixOS Wiki" = {
          urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
          icon = "https://wiki.nixos.org/nixos.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@nw" ];
        };
        "Noogλe" = {
          urls = [
            {
              template = "https://noogle.dev/q?term={searchTerms}";
            }
          ];
          icon = "https://wiki.nixos.org/nixos.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@noo" ];
        };
        "AUR - Packages" = {
          urls = [
            {
              template = "https://aur.archlinux.org/packages?K={searchTerms}";
            }
          ];
          icon = "https://wiki.archlinux.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@aur" ];
        };
        "Arch Wiki" = {
          urls = [ { template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; } ];
          icon = "https://wiki.archlinux.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@aw" ];
        };
        "StartPage" = {
          urls = [ { template = "https://www.startpage.com/sp/search?query={searchTerms}"; } ];
          icon = "https://www.startpage.com/sp/cdn/favicons/mobile/apple-icon-57x57.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@sp" ];
        };
      };
      search.default = "StartPage";
      search.force = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        canvasblocker
        darkreader
        fastforwardteam
        pywalfox
        plasma-integration
        return-youtube-dislikes
        sponsorblock
        tridactyl
        ublock-origin
        user-agent-string-switcher
        violentmonkey
      ];
      extensions.force = true;
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
  home.file.".librewolf/default/chrome".source = builtins.fetchGit {
    url = "https://github.com/debarchito/parfait";
    ref = "main";
    rev = "f3e83e71cd1ee19b1d7b4c55fc9d0cc4e112d5f7";
  };
}
