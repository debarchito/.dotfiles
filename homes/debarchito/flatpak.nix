{ lib, ... }:

{
  services.flatpak = {
    enable = true;
    remotes = lib.mkOptionDefault [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "io.github.flattool.Warehouse"
      "org.gnome.World.PikaBackup"
    ];
    update.auto.enable = true;
    update.auto.onCalendar = "daily";
  };
}
