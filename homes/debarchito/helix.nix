let
  common-options = {
    indent = {
      tab-width = 2;
      unit = " ";
    };
    auto-format = true;
  };
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
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
        rainbow-brackets = true;
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
          C-y = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
            ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
            ":set mouse false"
            ":set mouse true"
          ];
          A-j = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
          ];
          A-k = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];
        };
        insert.C-space = "completion";
      };
    };
    languages = {
      language-server = {
        codebook = {
          command = "codebook-lsp";
          args = [ "serve" ];
        };
        scls = {
          command = "simple-completion-language-server";
        };
      };
      language = [
        (
          {
            name = "nix";
            formatter.command = "nixfmt";
            language-servers = [
              "codebook"
              "nixd"
              "scls"
            ];
          }
          // common-options
        )
        (
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
              language-servers = [
                "codebook"
                "vscode-html-language-server"
                "scls"
              ];
            };
          }
          // common-options
        )
        (
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
            language-servers = [
              "codebook"
              "vscode-css-language-server"
              "scls"
            ];
          }
          // common-options
        )
        (
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
            language-servers = [
              "codebook"
              "vscode-json-language-server"
              "scls"
            ];
          }
          // common-options
        )
        (
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
            language-servers = [
              "codebook"
              "vscode-json-language-server"
              "scls"
            ];
          }
          // common-options
        )
        (
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
            language-servers = [
              "codebook"
              "yaml-language-server"
              "scls"
            ];
          }
          // common-options
        )
        (
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
            language-servers = [
              "codebook"
              "markdown-oxide"
              "scls"
            ];
          }
          // common-options
        )
        (
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
              language-servers = [
                "codebook"
                "scls"
              ];
            };
          }
          // common-options
        )
        (
          {
            name = "fish";
            formatter.command = "fish_indent";
            language-servers = [
              "codebook"
              "fish-lsp"
              "scls"
            ];
          }
          // common-options
        )
        (
          {
            name = "toml";
            formatter = {
              command = "taplo";
              args = [
                "format"
                "-"
              ];
            };
            language-servers = [
              "codebook"
              "taplo"
              "scls"
            ];
          }
          // common-options
        )
        (
          {
            name = "typst";
            formatter.command = "typstyle";
            language-servers = [
              "codebook"
              "tinymist"
              "scls"
            ];
          }
          // common-options
        )
        # these should use project-specific formatting
        {
          name = "rust";
          language-servers = [
            "codebook"
            "rust-analyzer"
            "scls"
          ];
        }
      ];
    };
  };
  xdg.configFile."helix/snippets/nix.json".source = ./helix/snippets/nix.json;
  xdg.configFile."helix/snippets/rust.json".source = ./helix/snippets/rust.json;
  xdg.configFile."helix/snippets/sql.json".source = ./helix/snippets/sql.json;
  xdg.configFile."helix/snippets/typst.json".source = ./helix/snippets/typst.json;
}
