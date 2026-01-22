{ pkgs, ... }:

{
  programs.rbw.enable = true;
  programs.rbw.settings.email = "debarchitonath@gmail.com";
  programs.rbw.settings.pinentry = pkgs.pinentry-qt;
}
