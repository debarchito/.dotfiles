{ lib, ... }:

{
  services.flatpak.enable = true;
  services.flatpak.remotes = lib.mkOptionDefault [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
  ];
  services.flatpak.packages = [
    "io.github.flattool.Warehouse"
    # I use flatpak for apps that I don't necessarily want in my config.
    # Use nixpkgs versions of apps whenever you can!
  ];
  services.flatpak.update.auto.enable = true;
  services.flatpak.update.auto.onCalendar = "daily";
}
