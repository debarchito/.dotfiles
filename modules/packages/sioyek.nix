{
  perSystem =
    { pkgs, ... }:
    {
      packages.sioyek = pkgs.sioyek.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/sioyek --set QT_QPA_PLATFORM xcb
        '';
      });
    };
}
