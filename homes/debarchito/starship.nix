{
  lib,
  inputs,
  system,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
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
        style = "bold #cba6f7";
      };
      directory.style = "#cba6f7";
      line_break.disabled = true;
      character = {
        success_symbol = "[ ](#cab4fe)";
        error_symbol = "[ ](#f38ba8)";
        vimcmd_symbol = "[ ](#a6e3a1)";
        vimcmd_visual_symbol = "[󰼢 ](#f9e2af)";
        vimcmd_replace_symbol = "[󰛔 * ](#eba0ac)";
        vimcmd_replace_one_symbol = "[󰛔 1 ](#eba0ac)";
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
        style = "cyan";
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
        style = "bold #cba6f7";
      };
      nix_shell = {
        format = "@ [󱄅 $name](bold #89b4fa) ";
      };
      python = {
        format = "@ [ $virtualenv](bold #cba6f7) ";
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
  };
  home.packages = [
    inputs.starship-jj.packages.${system}.starship-jj
  ];
  xdg.configFile."starship-jj/starship-jj.toml".source =
    ./starship/plugins/starship-jj/starship-jj.toml;
}
