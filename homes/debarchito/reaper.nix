{ pkgs, ... }:

{
  home.packages = [
    pkgs.reaper
  ];
  home.file.".lv2/neural_amp_modeler.lv2".source =
    "${pkgs.neural-amp-modeler-lv2}/lib/lv2/neural_amp_modeler.lv2";
}
