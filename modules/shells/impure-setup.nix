{
  perSystem =
    { pkgs, lib, ... }:
    let
      execute-impure-setup =
        pkgs.writers.writeFishBin "execute-impure-setup" { }
          # fish
          ''
            set ICON_DIR "''$HOME/.local/share/icons"
            set GIT "${pkgs.git}/bin/git"
            set REPO_URL "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git"
            set REPO_REV "702499f331aa9c38309e1af99de4021013916297"

            echo "[-*-] Setting up Papirus icon theme."

            if test -d "$ICON_DIR/Papirus"
              echo "[?] Papirus icon theme already exists as: $ICON_DIR/Papirus"
              echo "    [1] Remove existing theme and re-install."
              echo "    [2] Skip Papirus icon theme setup."
              
              read -l -P "Select an option [1/2*] : " confirm
              
              switch $confirm
                case 1
                  echo "[?] Removing existing Papirus installation."
                  rm -rf "$ICON_DIR/Papirus"
                case 2
                  echo "[?] Skipping Papirus icon theme setup."
                  set skip_papirus true
                case '*'
                  echo "[?] Defaulting to: Skip Papirus icon theme setup."
                  set skip_papirus true
              end
            end

            if not set -q skip_papirus
              echo "[-*-] Fetching Papirus icon theme."

              mkdir -p "$ICON_DIR"
              set TMP_DIR (mktemp -d)
              
              function cleanup --on-event fish_exit --inherit-variable TMP_DIR
                  rm -rf "$TMP_DIR"
              end

              "$GIT" -c advice.detachedHead=false clone \
                --revision=$REPO_REV \
                --depth=1 \
                --filter=blob:none \
                --sparse "$REPO_URL" "$TMP_DIR"
              "$GIT" -C "$TMP_DIR" sparse-checkout set Papirus

              echo "[-*-] Copying Papirus icon theme to: $ICON_DIR/Papirus"

              cp -r "$TMP_DIR/Papirus" "$ICON_DIR/Papirus"

              echo "[+] Successfully installed Papirus icon theme to: $ICON_DIR/Papirus"
            end

            echo "[-*-] Setting up pywalfox for LibreWolf."

            ${lib.getExe pkgs.pywalfox-native} install --browser librewolf

            mkdir -p "''$HOME/.cache/wal"
            ${pkgs.coreutils}/bin/ln -sf "''$HOME/.cache/wal/dank-pywalfox.json" "''$HOME/.cache/wal/colors.json"

            echo "[+] Successfully setup pywalfox for LibreWolf."
          '';
    in
    {
      devShells.impure-setup = pkgs.mkShellNoCC {
        name = "impure-setup";
        nativeBuildInputs = [
          pkgs.git
          pkgs.pywalfox-native
          execute-impure-setup
        ];
        shellHook = ''
          echo "[?] Setup shell loaded. Run \"execute-impure-setup\" to apply the setup changes."
        '';
      };
    };
}
