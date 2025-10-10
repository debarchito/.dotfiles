{ pkgs, ... }:

{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
