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
  programs.dank-material-shell.plugins = {
    appShortcut = {
      enable = true;
      src = fetchGit {
        url = "https://github.com/debarchito/appShortcut";
        ref = "main";
        rev = "373400a84e40b0fb73d6c809ea33c425b529c35f";
      };
    };
    calculator = {
      enable = true;
      src = fetchGit {
        url = "https://github.com/debarchito/calculator";
        ref = "main";
        rev = "de6dbd59b7630e897a50e107f704c1cd4a131128";
      };
    };
    commandRunner = {
      enable = true;
      src = fetchGit {
        url = "https://github.com/debarchito/commandRunner";
        ref = "main";
        rev = "3739e3b8a07e36fc52dbe76130574aab10e3a36e";
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
    dankKDEConnect = {
      enable = true;
      src = "${
        fetchGit {
          url = "https://github.com/debarchito/dms-plugins";
          ref = "master";
          rev = "bd1033ed94647bf6753b1337148480598e3a7a25";
        }
      }/DankKDEConnect";
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
        rev = "2951ec7f823c983c11b6b231403581a386a7c9f6";
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
        rev = "81ccd9fd8249b3c9ef40dde42549f807e36ae3e3";
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
