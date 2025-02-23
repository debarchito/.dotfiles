{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        bufferline = "multiple";
        color-modes = true;
        completion-replace = true;
        line-number = "relative";
        true-color = true;
        scroll-lines = 1;
        idle-timeout = 200;
        end-of-line-diagnostics = "hint";
        file-picker.hidden = false;
        statusline = {
          left = [
            "mode"
            "spacer"
            "version-control"
            "spacer"
            "file-name"
            "file-modification-indicator"
          ];
          right = [
            "spinner"
            "spacer"
            "workspace-diagnostics"
            "spacer"
            "diagnostics"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
        };
        cursor-shape.insert = "bar";
        indent-guides = {
          render = true;
          character = "╎";
        };
        soft-wrap = {
          enable = true;
          max-wrap = 10;
        };
        inline-diagnostics.cursor-line = "error";
      };
      keys = {
        normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
            ":w"
          ];
          g = {
            q = ":bc";
            Q = ":bc!";
          };
        };
        insert.C-space = "completion";
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          formatter.command = "nixfmt";
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "typst";
          formatter.command = "typstyle";
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "html";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "html"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "css";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "css"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "json";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "json"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "jsonc";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "jsonc"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "yaml";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "yaml"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "toml";
          formatter = {
            command = "taplo";
            args = [
              "format"
              "-"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "markdown";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "md"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "sql";
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "-"
              "--ext"
              "sql"
            ];
          };
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "fish";
          formatter.command = "fish_indent";
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
      ];
    };
  };
}
