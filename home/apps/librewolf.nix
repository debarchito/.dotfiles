{ config, pkgs, ... }:

# NOTE: Enable permissions for extensions manually; this is how I prefer it.
# NOTE: The configurations here are supposed to be treated as "bare-minimum" base that I can build upon.
# NOTE: I do not want or need to use the exact same browser configs every time.

{
  programs.librewolf = {
    enable = true;
    package = config.lib.nixGL.wrapOffload pkgs.librewolf;
    profiles.debarchito = {
      isDefault = true;
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@np" ];
        };
        "NixOS Wiki" = {
          urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@nw" ];
        };
        "Arch Wiki" = {
          urls = [ { template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; } ];
          iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@aw" ];
        };
        "SearXNG" = {
          urls = [ { template = "https://search.inetol.net/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://search.inetol.net/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@sr" ];
        };
        "Bing".metaData.hidden = true;
      };
      search.default = "SearXNG";
      search.force = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        clearurls
        darkreader
        decentraleyes
        foxytab
        firefox-color
        fastforwardteam
        foxyproxy-standard
        firefox-translations
        privacy-badger
        read-aloud
        return-youtube-dislikes
        sponsorblock
        stylus
        tabliss
        ublock-origin
        user-agent-string-switcher
        violentmonkey
        web-archives
      ];
      settings = {
        "places.history.enabled" = false;
        "layout.css.has-selector.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
      };
      userChrome = builtins.readFile ./librewolf/userChrome.css;
      userContent = builtins.readFile ./librewolf/userContent.css;
    };
  };
}
