{
  programs.fzf = {
    enable = true;
    # enableFishIntegration = true; --> handled by fzf.fish plugin.
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
    changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -200'" ];
    fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetOptions = [ "--preview 'bat --color=always -n --line-range :500 {}'" ];
    colors = {
      bg = "#1e1e2e";
      "bg+" = "#313244";
      fg = "#cdd6f4";
      "fg+" = "#cdd6f4";
      hl = "#f38ba8";
      "hl+" = "#f38ba8";
      header = "#f38ba8";
      info = "#cba6f7";
      marker = "#b4befe";
      prompt = "#cba6f7";
      pointer = "#f5e0dc";
      spinner = "#f5e0dc";
      "selected-bg" = "#45475a";
    };
  };
}
