{ lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "astro"
      "docker-compose"
      "dockerfile"
      "git-firefly"
      "html"
      "nix"
      "sql"
      "svelte"
      "toml"
    ];
    userSettings = {
      theme = {
        mode = "system";
        light = lib.mkForce "Matugen Light";
        dark = "Matugen Dark";
      };
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Maple Mono NF";
      relative_line_numbers = "enabled";
      title_bar = {
        show_sign_in = false;
        show_user_picture = false;
      };
      terminal = {
        font_family = "Maple Mono NF";
        shell.program = "fish";
      };
      languages.Nix.language_servers = [ "nixd" ];
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      disable_ai = true;
      helix_mode = true;
    };
  };
}
