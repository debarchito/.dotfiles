{
  flake.templates = {
    default = {
      path = ./_templates/default;
      description = "default template";
    };

    ocaml = {
      path = ./_templates/ocaml;
      description = "opam-nix template";
    };
  };
}
