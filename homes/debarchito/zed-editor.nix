{ lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "astro"
      "catppuccin"
      "catppuccin-icons"
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
      icon_theme = "Catppuccin Mocha";
      theme = {
        mode = "system";
        light = lib.mkForce "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Maple Mono NF";
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
    };
  };
}
