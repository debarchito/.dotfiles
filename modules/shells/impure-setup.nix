{
  perSystem =
    { pkgs, ... }:
    let
      execute-impure-setup =
        pkgs.writers.writeFishBin "execute-impure-setup" { }
          # fish
          ''
            set ICON_DIR "$HOME/.local/share/icons"
            set GIT "${pkgs.git}/bin/git"
            set REPO_URL "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git"
            set REPO_REV "702499f331aa9c38309e1af99de4021013916297"

            if test -d "$ICON_DIR/Papirus"
              echo "[!] Papirus icon theme already exists as: $ICON_DIR/Papirus"
              echo "[?] Run \"rm -rf $ICON_DIR/Papirus\" followed by this setup script to retry."
              exit 0
            end

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
          '';
    in
    {
      devShells.impure-setup = pkgs.mkShellNoCC {
        name = "impure-setup";
        nativeBuildInputs = [
          pkgs.git
          execute-impure-setup
        ];
        shellHook = ''
          echo "[?] Setup shell loaded. Run \"execute-impure-setup\" to apply the setup changes."
        '';
      };
    };
}
