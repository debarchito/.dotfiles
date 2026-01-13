{ lib, pkgs, ... }:

{
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.starship.settings = {
    format = lib.concatStrings [
      "$username"
      "$hostname"
      "$os"
      "$directory"
      "$pijul_channel"
      "$\{custom.jj}"
      "$git_branch"
      "$git_state"
      "$git_status"
      "$cmd_duration"
      "$line_break"
      "$nix_shell"
      "$python"
      "$character"
    ];
    hostname.ssh_symbol = " ";
    os = {
      disabled = false;
      symbols = {
        Arch = "󰣇 ";
        Debian = " ";
        Fedora = " ";
        NixOS = "󱄅 ";
      };
      style = "bold cyan";
    };
    directory.style = "cyan";
    line_break.disabled = true;
    character = {
      success_symbol = "[ ](cyan)";
      error_symbol = "[ ](red)";
      vimcmd_symbol = "[ ](green)";
      vimcmd_visual_symbol = "[󰼢 ](orange)";
      vimcmd_replace_symbol = "[󰛔 * ](orange)";
      vimcmd_replace_one_symbol = "[󰛔 1 ](orange)";
    };
    pijul_channel = {
      disabled = false;
      format = "[󰬗  $channel]($style) ";
      style = "bright-black";
    };
    git_branch = {
      format = "[  $branch]($style)";
      style = "bright-black";
    };
    git_status = {
      format = "[[($conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead$behind$stashed$diverged)]($style)";
      style = "orange";
      conflicted = " ⚠";
      untracked = " ?";
      modified = " ✎";
      staged = " ●";
      renamed = " »";
      deleted = " ⌫";
      stashed = " ≡";
      ahead = " ⇡";
      behind = " ⇣";
      diverged = " ⇕";
    };
    git_state = {
      format = "\([$state( $progress_current/$progress_total)]($style)\) ";
      style = "bright-black";
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bold cyan";
    };
    nix_shell = {
      format = "@ [󱄅 $name](bold blue) ";
    };
    python = {
      format = "@ [ $virtualenv](bold cyan) ";
    };
    custom.jj = {
      command = "prompt";
      format = "$output";
      ignore_timeout = true;
      shell = [
        "starship-jj"
        "--ignore-working-copy"
        "starship"
      ];
      use_stdin = false;
      when = true;
    };
  };

  home.packages = [
    pkgs.starship-jj
  ];

  xdg.configFile."starship-jj/starship-jj.toml".source =
    ./starship/plugins/starship-jj/starship-jj.toml;
}
