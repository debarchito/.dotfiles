{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    environment = {
      systemPackages = with pkgs; [
        acpi
        nvme-cli
      ];
    };
  };
}
