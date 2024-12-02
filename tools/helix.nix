{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        scroll-lines = 1;
        auto-format = true;
        idle-timeout = 200;
        soft-wrap.enable = true;
        bufferline = "multiple";
        line-number = "relative";
        file-picker.hidden = false;
        lsp.display-messages = true;
        cursor-shape.insert = "bar";
        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-base-name" ];
        };
      };
      keys.normal.esc = [ "collapse_selection" "keep_primary_selection" ];
    };
  };
}
