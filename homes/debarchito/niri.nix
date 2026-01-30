{ pkgs, ... }:

let
  qt6ct = pkgs.qt6Packages.qt6ct.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      ./_patches/qt6ct.patch
    ];
  });
in
{
  programs.niri.config = null;

  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  programs.dank-material-shell.enable = true;
  programs.dank-material-shell.niri = {
    enableSpawn = true;
    includes.enable = false;
  };
  programs.dank-material-shell.enableSystemMonitoring = true;
  programs.dank-material-shell.enableVPN = true;
  programs.dank-material-shell.enableDynamicTheming = true;
  programs.dank-material-shell.enableAudioWavelength = true;
  programs.dank-material-shell.enableCalendarEvents = true;
  programs.dank-material-shell.plugins =
    let
      officialDankModules = fetchGit {
        url = "https://github.com/debarchito/dms-plugins";
        ref = "master";
        rev = "738293e3ef5441dfc928aefea34c1e63cb1180aa";
      };
    in
    {
      appShortcut = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/appShortcut";
          ref = "main";
          rev = "373400a84e40b0fb73d6c809ea33c425b529c35f";
        };
      };
      commandRunner = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/commandRunner";
          ref = "main";
          rev = "49232a1e5b8dc34b00561160c49c3ad3300629d3";
        };
      };
      displayMirror = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/displayMirror";
          ref = "main";
          rev = "92cd44c4fb67834bf71fdd78f83c29df5e0750b2";
        };
      };
      dockerManager = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/dockerManager";
          ref = "main";
          rev = "860457bbb043a6651a2cbafe6e77d443123a0b07";
        };
      };
      dankBitwarden = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/dankBitwarden";
          ref = "main";
          rev = "df4cf77ed4c06639f19f7a3ce8fb8bc00850ff67";
        };
      };
      dankKDEConnect = {
        enable = true;
        src = "${officialDankModules}/DankKDEConnect";
      };
      dankNotepadModule = {
        enable = true;
        src = "${officialDankModules}/DankNotepadModule";
      };
      easyEffects = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/easyEffects";
          ref = "main";
          rev = "f50fdb7a110ddb90b7625bc143884fd773c3d5c7";
        };
      };
      emojiLauncher = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/emojiLauncher";
          ref = "main";
          rev = "9bbc5c0b0c41977dcdbacc49ae63c6d8b8670536";
        };
      };
      niriWindows = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/niriWindows";
          ref = "main";
          rev = "2ae932e21a4491af27329dfff8b4f1514d0a4657";
        };
      };
      webSearch = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/webSearch";
          ref = "main";
          rev = "d383a5433bec0375e45b6bd4c81c2c05a4c20be1";
        };
      };
    };

  xdg.configFile."DankMaterialShell/settings.json".source = ./niri/dankmaterialshell/settings.json;
  xdg.configFile."DankMaterialShell/plugin_settings.json".source =
    ./niri/dankmaterialshell/plugin_settings.json;

  xdg.configFile."matugen/templates".source = ./niri/dankmaterialshell/matugen/templates;
  xdg.configFile."matugen/config.toml".source = ./niri/dankmaterialshell/matugen/config.toml;

  home.packages = [
    pkgs.dsearch
    pkgs.nautilus
    pkgs.pywal
    pkgs.pywalfox-native
    pkgs.xwayland-satellite
    qt6ct
  ];
}
