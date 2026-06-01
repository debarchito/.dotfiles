{ inputs, moduleWithSystem, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # overlays = [
        #   # Required for: ../packages/bottles.nix
        #   (_: prev: {
        #     openldap = prev.openldap.overrideAttrs (_: {
        #       doCheck = !prev.stdenv.hostPlatform.isi686;
        #     });
        #   })
        # ];
      };
    };

  flake.modules.nixos.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          inherit (self'.packages)
            waydroid-choose-gpu
            waydroid-script
            ;
        })
      ];
    }
  );

  flake.modules.homeManager.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          inherit (self'.packages)
            blender
            bottles
            generate
            helium
            neuralrack
            obs-studio
            papirus-folders
            pinentry-dms
            prismlauncher-unwrapped
            qt6ct
            ratatouille
            reaper
            sioyek
            starship-jj
            wiiudownloader
            ;
        })
      ];
    }
  );
}
