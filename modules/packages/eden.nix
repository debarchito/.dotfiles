{
  perSystem =
    { pkgs, ... }:
    {
      packages.eden = pkgs.eden.overrideAttrs (oldAttrs: rec {
        pname = "eden";
        version = "0.2.0";

        src = pkgs.fetchFromGitea {
          domain = "git.eden-emu.dev";
          owner = "eden-emu";
          repo = "eden";
          tag = "v${version}";
          hash = "sha256-tkro7ZHgn2809Utf/Li5+OiseywyQKH15eqphxlJZQQ=";
        };
      });
    };
}
