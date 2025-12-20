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
      # I use flatpak for apps that I don't necessarily want in my config.
      # Use nixpkgs versions of apps whenever you can!
    ];
    update.auto.enable = true;
    update.auto.onCalendar = "daily";
  };
}
