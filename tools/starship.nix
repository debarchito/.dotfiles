{ pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$nix_shell"
        "$python"
        "$character"
      ];
      directory.style = "#74c7ec";
      line_break.disabled = true;
      character = {
        success_symbol = "[❯](#b4befe)";
        error_symbol = "[❯](#f38ba8)";
        vimcmd_symbol = "[❮](#a6e3a1)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[ [($conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "⚔️";
        untracked = "✚";
        modified = "✎";
        staged = "●";
        renamed = "➜";
        deleted = "✖";
        stashed = "≡";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bold blue";
      };
      nix_shell = {
        format = "@ [$name]($style) ";
        style = "bold blue";
      };
      python = {
        format = "@ [$virtualenv]($style) ";
        style = "bold blue";
      };
    };
  };
}
