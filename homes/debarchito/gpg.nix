{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent.enable = true;
  services.gpg-agent.enableFishIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-qt;
}
