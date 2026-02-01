{ pkgs, ... }:

{
  home.packages = [
    (pkgs.reaper.overrideAttrs (_: {
      version = "7.60";
      src = pkgs.fetchurl {
        url = "https://www.reaper.fm/files/7.x/reaper760_linux_x86_64.tar.xz";
        hash = "sha256-I3P4hTI1QGufmpeQGet5YkLB6A4FiRPFC6MehUKGRCU=";
      };
    }))
    pkgs.yabridge
    pkgs.yabridgectl
  ];

  home.file.".lv2/neural_amp_modeler.lv2".source =
    "${pkgs.neural-amp-modeler-lv2}/lib/lv2/neural_amp_modeler.lv2";
}
