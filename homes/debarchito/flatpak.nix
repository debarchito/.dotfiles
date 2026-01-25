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
    "com.github.tchx84.Flatseal"
    "io.github.flattool.Warehouse"
    "org.gnome.World.PikaBackup"
    "org.kde.kdenlive"
    # NOTE: I generally use flatpak apps for very specific scenarios where the nixpkgs version doesn't cut it.
  ];
  services.flatpak.update.auto.enable = true;
  services.flatpak.update.auto.onCalendar = "daily";
}
