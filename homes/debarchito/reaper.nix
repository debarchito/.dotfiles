{ pkgs, ... }:

{
  home.packages = [
    (pkgs.reaper.overrideAttrs (_: {
      version = "7.59";
      src = pkgs.fetchurl {
        url = "https://www.reaper.fm/files/7.x/reaper759_linux_x86_64.tar.xz";
        hash = "sha256-II2QOv7eHD4JtE5We1uuEuCt5RZmK6VFtZFyLEArUSc=";
      };
    }))
    pkgs.yabridge
    pkgs.yabridgectl
  ];

  home.file.".lv2/neural_amp_modeler.lv2".source =
    "${pkgs.neural-amp-modeler-lv2}/lib/lv2/neural_amp_modeler.lv2";
}
