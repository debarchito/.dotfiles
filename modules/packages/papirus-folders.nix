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
            mkdir -p $out/bin
            makeWrapper ${pkgs.papirus-folders}/bin/papirus-folders $out/bin/papirus-folders \
              --prefix PATH : ${lib.makeBinPath [ pkgs.gtk3 ]}
          '';
    };
}
