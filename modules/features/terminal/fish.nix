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
        programs.fish = {
          enable = true;
          plugins = [
            {
              name = "pisces";
              src = pkgs.fishPlugins.pisces.src;
            }
            {
              name = "fzf.fish";
              src = pkgs.fishPlugins.fzf-fish.src;
            }
            {
              name = "puffer";
              src = pkgs.fishPlugins.puffer.src;
            }
            {
              name = "foreign-env";
              src = pkgs.fishPlugins.foreign-env.src;
            }
            {
              name = "transient-fish";
              src = pkgs.fishPlugins.transient-fish.src;
            }
            {
              name = "colored-man-pages";
              src = pkgs.fishPlugins.colored-man-pages.src;
            }
            {
              name = "forgit";
              src = pkgs.fishPlugins.forgit.src;
            }
          ];
          functions = {
            __fish_user_key_bindings =
              # fish
              ''
                fish_vi_key_bindings default 2>/dev/null
                bind -M insert \cg __fish_rga_fzf
                bind -M default \cg __fish_rga_fzf
              '';
            __fish_which = "command --search (string sub --start=2 $argv)";
            __fish_rga_fzf =
              # fish
              ''
                set RG_PREFIX 'rga --files-with-matches'
                set selected (
                  FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
                        --ansi \
                        --disabled \
                        --query "$1" \
                        --preview "rga --pretty --context 5 {q} {}" \
                        --preview-window "70%:wrap"
                )
                if test -n "$selected"
                  echo $selected
                  commandline -i $selected
                  commandline -f repaint
                end
              '';
            __fish_nix_search =
              # fish
              ''
                set -l result (nix-search-tv print \
                  | fzf --preview 'nix-search-tv preview {}' --scheme history \
                  | rg --color=never -o '[^ ]+$' \
                  | tr -d '\n')
                if test -n "$result"
                    echo $result
                else
                    echo $argv[1]
                end
              '';
            run =
              # fish
              ''
                if test (count $argv) -eq 0
                  echo "Usage: run <package> [<args>...]"
                  return 1
                end
                nix run nixpkgs#$argv[1] -- $argv[2..-1]
              '';
            runu =
              # fish
              ''
                if test (count $argv) -eq 0
                  echo "Usage: runu <package> [<args>...]"
                  return 1
                end
                NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$argv[1] -- $argv[2..-1]
              '';
            shell =
              # fish
              ''
                if test (count $argv) -eq 0
                  echo "Usage: shell <package> [<package>...]"
                  return 1
                end
                set pkgs
                for pkg in $argv
                  set -a pkgs nixpkgs#$pkg
                end
                nom shell $pkgs --command fish
              '';
          };
          interactiveShellInit =
            # fish
            ''
              set fish_greeting
              set -gx fish_key_bindings __fish_user_key_bindings
              set -gx PATH $PATH $HOME/.local/bin
            '';
          preferAbbrs = true;
          shellAbbrs = {
            cd = "z";
            cgh = {
              setCursor = "%";
              expansion = "jj git clone gh:%";
            };
            cgl = {
              setCursor = "%";
              expansion = "jj git clone gl:%";
            };
            ccb = {
              setCursor = "%";
              expansion = "jj git clone cb:%";
            };
            cmgh = {
              setCursor = "%";
              expansion = "jj git clone me@gh:%";
            };
            cmcb = {
              setCursor = "%";
              expansion = "jj git clone me@cb:%";
            };
            jd = {
              setCursor = "%";
              expansion = ''jj desc -r % -m "$(koji --stdout)"'';
            };
            jl = {
              setCursor = "%";
              expansion = "jj log -r .. -n % --no-pager";
            };
            jh = {
              setCursor = "%";
              expansion = "jj log -r 'heads(all())' -n % --no-pager";
            };
            jbmc = {
              setCursor = "%";
              expansion = "jj bookmark move -f % -t @";
            };
            jbmb = {
              setCursor = "%";
              expansion = "jj bookmark move -f % -t @-";
            };
            jbmat = {
              setCursor = "%";
              expansion = "jj bookmark move -f 'heads(..@- & bookmarks())' -t %";
            };
            sns = {
              setCursor = "%";
              expansion = "fd % /nix/store | fzf";
            };
            "=" = {
              regex = ''=[^\s]+'';
              position = "anywhere";
              function = "__fish_which";
            };
            "~ns" = {
              position = "anywhere";
              function = "__fish_nix_search";
            };
          };
        };
      };
    };
}
