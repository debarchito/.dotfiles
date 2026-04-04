{ inputs, moduleWithSystem, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  flake.modules.nixos.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (self'.packages) waydroid-choose-gpu waydroid-script;
        })
      ];
    }
  );

  flake.modules.homeManager.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: _: {
          inherit (self'.packages)
            blender
            bottles
            generate
            helium
            obs-studio
            papirus-folders
            qt6ct
            reaper
            sioyek
            starship-jj
            ;
        })
      ];
    }
  );
}
