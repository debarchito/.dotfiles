{
  flake.modules.homeManager.options-editors =
    { lib, config, ... }:
    {

      options.editors = lib.mkOption {
        type = lib.types.submodule {
          options = {
            zed-editor.enable = lib.mkEnableOption "enable zed editor";
          };
        };
        default = { };
      };

      config = lib.mkIf config.editors.zed-editor.enable {
        programs.zed-editor = {
          enable = true;
          userSettings = {
            theme = {
              mode = "system";
              light = "Matugen Light";
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
            telemetry = {
              metrics = false;
              diagnostics = false;
            };
            disable_ai = true;
            helix_mode = true;
          };
        };
      };
    };
}
