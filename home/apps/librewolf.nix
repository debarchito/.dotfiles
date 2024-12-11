{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    profiles.debarchito = {
      isDefault = true;
      search.engines = {
        "Nix Packages" = {
          urls = [{
          template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@np" ];
        };
        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@nw" ];
        };
        "Arch Wiki" = {
          urls = [{ template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@aw" ];
        };
        "SearXNG" = {
          urls = [{ template = "https://search.inetol.net/search?q={searchTerms}"; }];
          iconUpdateURL = "https://search.inetol.net/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@sr" ];
        };
        "Bing".metaData.hidden = true;
      };
      search.force = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
      ];
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = builtins.readFile ./librewolf/userChrome.css;
    };
  };
}
