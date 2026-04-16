{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.papirus-folders =
        pkgs.runCommand "papirus-folders"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
          }
          ''
            ${lib.getExe' pkgs.coreutils "mkdir"} -p $out/bin
            makeWrapper ${lib.getExe pkgs.papirus-folders} $out/bin/papirus-folders \
              --prefix PATH : ${lib.makeBinPath [ pkgs.gtk3 ]}
          '';
    };
}
