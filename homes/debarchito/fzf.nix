{
  programs.fzf.enable = true;
  programs.fzf.defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
  programs.fzf.changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
  programs.fzf.changeDirWidgetOptions = [ "--preview 'eza --tree --color=always {} | head -200'" ];
  programs.fzf.fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
  programs.fzf.fileWidgetOptions = [ "--preview 'bat --color=always -n --line-range :500 {}'" ];
}
