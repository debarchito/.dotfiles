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
        rev = "b4e59f331a4ba4ba12e114a646b5814f07b950c9";
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
          rev = "933b4770e15da95db3decc26b321ca20eb08c05a";
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
          rev = "f6d3b734b84f81b272ea4f9ab88d5f3470aa3551";
        };
      };
      niriWindows = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/niriWindows";
          ref = "main";
          rev = "b845277ad505556caff828241ec6a80a75f0e034";
        };
      };
      webSearch = {
        enable = true;
        src = fetchGit {
          url = "https://github.com/debarchito/webSearch";
          ref = "main";
          rev = "de9d645a12135f840262298f42e462955e40d992";
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
