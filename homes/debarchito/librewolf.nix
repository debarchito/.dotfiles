{ pkgs, pkgs-librewolf, ... }:

{
  programs.librewolf = {
    enable = true;
    package = pkgs-librewolf.librewolf;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
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
      };
      search.default = "StartPage";
      search.force = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        canvasblocker
        darkreader
        firefox-color
        fastforwardteam
        foxyproxy-standard
        plasma-integration
        return-youtube-dislikes
        sponsorblock
        tabliss
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
            url = "https://safereddit.com";
          }
          {
            name = "XCancel";
            url = "https://xcancel.com";
          }
          {
            name = "Invidious";
            url = "https://yewtu.be";
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
            name = "Tuta";
            url = "https://app.tuta.com";
          }
          {
            name = "ProtonMail";
            url = "https://mail.proton.me";
          }
        ];
      };
      settings = {
        "places.history.enabled" = false;
        "layout.css.has-selector.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "widget.gtk.non-native-titlebar-buttons.enabled" = true;
        "widget.gtk.titlebar-action-middle-click-enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
      userChrome = builtins.readFile ./librewolf/userChrome.css;
      userContent = builtins.readFile ./librewolf/userContent.css;
    };
  };
}
