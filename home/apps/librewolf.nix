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
  home.file.".librewolf/debarchito/chrome/includes/cascade-tabs.css".text = builtins.readFile ./librewolf/includes/cascade-tabs.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-config.css".text = builtins.readFile ./librewolf/includes/cascade-config.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-layout.css".text = builtins.readFile ./librewolf/includes/cascade-layout.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-colours.css".text = builtins.readFile ./librewolf/includes/cascade-colours.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-nav-bar.css".text = builtins.readFile ./librewolf/includes/cascade-nav-bar.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-responsive.css".text = builtins.readFile ./librewolf/includes/cascade-responsive.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-config-mouse.css".text = builtins.readFile ./librewolf/includes/cascade-config-mouse.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-floating-panel.css".text = builtins.readFile ./librewolf/includes/cascade-floating-panel.css;
  home.file.".librewolf/debarchito/chrome/includes/cascade-responsive-windows-fix.css".text = builtins.readFile ./librewolf/includes/cascade-responsive-windows-fix.css;
}
