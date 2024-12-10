{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    profiles.debarchito = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
      ];
    };
  };
}
