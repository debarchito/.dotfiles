{
  services.flatpak = {
    enable = true;
    remotes = [
      { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
      { name = "launcher.moe"; location = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo"; }
      { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
    ];
    packages = [
      # Apps
      { appId = "org.kde.gwenview"; origin = "flathub"; }
      { appId = "net.nokyan.Resources"; origin = "flathub"; }
      { appId = "it.mijorus.gearlever"; origin = "flathub"; }
      { appId = "md.obsidian.Obsidian"; origin = "flathub"; }
      { appId = "org.inkscape.Inkscape"; origin = "flathub"; }
      { appId = "com.obsproject.Studio"; origin = "flathub"; }
      { appId = "com.usebottles.bottles"; origin = "flathub"; }
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
      { appId = "org.qbittorrent.qBittorrent"; origin = "flathub"; }
      { appId = "org.localsend.localsend_app"; origin = "flathub"; }
      { appId = "io.github.flattool.Warehouse"; origin = "flathub"; }
      { appId = "org.onlyoffice.desktopeditors"; origin = "flathub"; }
      { appId = "com.github.johnfactotum.Foliate"; origin = "flathub"; }
      { appId = "com.github.unrud.VideoDownloader"; origin = "flathub"; }
      { appId = "com.github.finefindus.eyedropper"; origin = "flathub"; }
      { appId = "io.github.kukuruzka165.materialgram"; origin = "flathub"; }
      # Gaming
      { appId = "com.valvesoftware.Steam"; origin = "flathub"; }
      { appId = "moe.launcher.sleepy-launcher"; origin = "launcher.moe"; }
      { appId = "moe.launcher.honkers-launcher"; origin = "launcher.moe"; }
      { appId = "moe.launcher.an-anime-game-launcher"; origin = "launcher.moe"; }
      { appId = "moe.launcher.the-honkers-railway-launcher"; origin = "launcher.moe"; }
      # Others
      { appId = "org.freedesktop.Platform.VulkanLayer.vkBasalt"; origin = "flathub"; }
      { appId = "org.freedesktop.Platform.VulkanLayer.gamescope"; origin = "flathub"; }
    ];
    update.auto.enable = true;
    update.auto.onCalendar = "daily";
  };
}
