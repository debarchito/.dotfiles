{ pkgs, ... }:

{
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
    interactiveShellInit = ''
      set fish_greeting
      set -gx PATH $PATH $HOME/.local/bin
      echo && bat -p ~/.config/default/cat.txt -l nix
    '';
    preferAbbrs = true;
    shellAbbrs = {
      cd = "z";
      ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
      cgh = {
        setCursor = "%";
        expansion = "jj git clone gh:% --colocate";
      };
      cgl = {
        setCursor = "%";
        expansion = "jj git clone gl:% --colocate";
      };
      ccb = {
        setCursor = "%";
        expansion = "jj git clone cb:% --colocate";
      };
      cmgh = {
        setCursor = "%";
        expansion = "jj git clone me@gh:% --colocate";
      };
      cmcb = {
        setCursor = "%";
        expansion = "jj git clone me@cb:% --colocate";
      };
      jjk = {
        setCursor = "%";
        expansion = ''jj describe -r % -m "$(koji --stdout)"'';
      };
      jjl = {
        setCursor = "%";
        expansion = "jj log -r :: -n % --no-pager";
      };
      jjh = {
        setCursor = "%";
        expansion = "jj log -r 'heads(all())' -n % --no-pager";
      };
    };
    functions = {
      run = ''
        if test (count $argv) -eq 0
          echo "Usage: run <package> [<args>...]"
          return 1
        end
        nix run nixpkgs#$argv[1] -- $argv[2..-1]
      '';
      runu = ''
        if test (count $argv) -eq 0
          echo "Usage: runu <package> [<args>...]"
          return 1
        end
        NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$argv[1] -- $argv[2..-1]
      '';
      shell = ''
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
  };
}
