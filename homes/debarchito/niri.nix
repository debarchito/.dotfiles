{ pkgs, ... }:

let
  qt6ct = pkgs.qt6Packages.qt6ct.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      ./patches/qt6ct.patch
    ];
  });
in
{
  programs.niri.config = null;
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    plugins = {
      displayMirror = {
        enable = true;
        src = builtins.fetchGit {
          url = "https://github.com/debarchito/displayMirror";
          ref = "main";
          rev = "92cd44c4fb67834bf71fdd78f83c29df5e0750b2";
        };
      };
      dockerManager = {
        enable = true;
        src = builtins.fetchGit {
          url = "https://github.com/debarchito/dockerManager";
          ref = "main";
          rev = "860457bbb043a6651a2cbafe6e77d443123a0b07";
        };
      };
      easyEffects = {
        enable = true;
        src = builtins.fetchGit {
          url = "https://github.com/debarchito/easyEffects";
          ref = "main";
          rev = "f50fdb7a110ddb90b7625bc143884fd773c3d5c7";
        };
      };
    };
  };

  home.packages = [
    pkgs.dsearch
    pkgs.nautilus
    pkgs.pywal
    pkgs.pywalfox-native
    qt6ct
    pkgs.xwayland-run
    pkgs.xwayland-satellite
  ];
}
