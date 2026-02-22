{
  flake.modules.homeManager.options-terminal =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.terminal.common.enable {
        programs.helix = {
          enable = true;
          settings = {
            theme = "dankcolors";
            editor = {
              popup-border = "popup";
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
              inline-diagnostics.cursor-line = "hint";
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
                C-i = ":toggle-option lsp.display-inlay-hints";
                C-y =
                  let
                    buffer = "/tmp/yazi-buffer";
                  in
                  [
                    ":sh rm -f ${buffer}"
                    ":insert-output ${pkgs.yazi}/bin/yazi \"%{buffer_name}\" --chooser-file=${buffer}"
                    ":insert-output ${pkgs.coreutils}/bin/echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
                    ":open %sh{${pkgs.coreutils}/bin/cat ${buffer}}"
                    ":redraw"
                    ":set mouse false"
                    ":set mouse true"
                  ];
              };
              insert.C-space = "completion";
            };
          };
          languages = {
            language-server = {
              spellcheck = {
                command = "${pkgs.codebook}/bin/codebook-lsp";
                args = [ "serve" ];
              };
              completion.command = "${pkgs.simple-completion-language-server}/bin/simple-completion-language-server";
              nix.command = "${pkgs.nixd}/bin/nixd";
              html.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
              css.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
              json.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
              yaml.command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
              markdown.command = "${pkgs.markdown-oxide}/bin/markdown-oxide";
              fish.command = "${pkgs.fish-lsp}/bin/fish-lsp";
              toml.command = "${pkgs.taplo}/bin/taplo";
              typst.command = "${pkgs.tinymist}/bin/tinymist";
            };
            language =
              let
                deno = "${pkgs.deno}/bin/deno";
                common-options = {
                  indent = {
                    tab-width = 2;
                    unit = " ";
                  };
                  auto-format = true;
                };
              in
              [
                (
                  {
                    name = "nix";
                    formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
                    language-servers = [
                      "spellcheck"
                      "nix"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "html";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "html"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "html"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "css";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "css"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "css"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "json";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "json"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "json"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "jsonc";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "jsonc"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "json"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "yaml";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "yaml"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "yaml"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "markdown";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "md"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "markdown"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "sql";
                    formatter = {
                      command = deno;
                      args = [
                        "fmt"
                        "-"
                        "--ext"
                        "sql"
                      ];
                      language-servers = [
                        "spellcheck"
                        "completion"
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
                      "spellcheck"
                      "fish"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "toml";
                    formatter = {
                      command = "${pkgs.taplo}/bin/taplo";
                      args = [
                        "format"
                        "-"
                      ];
                    };
                    language-servers = [
                      "spellcheck"
                      "toml"
                      "completion"
                    ];
                  }
                  // common-options
                )
                (
                  {
                    name = "typst";
                    formatter.command = "${pkgs.typstyle}/bin/typstyle";
                    language-servers = [
                      "spellcheck"
                      "typst"
                      "completion"
                    ];
                  }
                  // common-options
                )
                # NOTE: Configurations for these languages are expected to be project specific.
                # NOTE: These options exist just to inject the special LSPs.
                {
                  name = "rust";
                  language-servers = [
                    "spellcheck"
                    "rust-analyzer"
                    "completion"
                  ];
                }
                {
                  name = "ocaml";
                  language-servers = [
                    "spellcheck"
                    "ocamllsp"
                    "completion"
                  ];
                }
              ];
          };
        };

        xdg.configFile."helix/snippets".source = ./helix/snippets;
      };
    };
}
