{ pkgs, ... }:

{
  home.packages = [
    (pkgs.reaper.overrideAttrs (_: {
      version = "7.61";
      src = pkgs.fetchurl {
        url = "https://www.reaper.fm/files/7.x/reaper761_linux_x86_64.tar.xz";
        hash = "sha256-NioXFiUNO2TzJn0xhoQKEWb8OD7HD8O+sHAf4enopxg=";
      };
    }))
    pkgs.yabridge
    pkgs.yabridgectl
  ];

  home.file.".lv2/neural_amp_modeler.lv2".source =
    "${pkgs.neural-amp-modeler-lv2}/lib/lv2/neural_amp_modeler.lv2";
}
