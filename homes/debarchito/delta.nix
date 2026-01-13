{
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
  programs.delta.enableJujutsuIntegration = true;
  programs.delta.options = {
    side-by-side = true;
    line-numbers = true;
    true-color = "always";
    merge.conflictStyle = "zdiff3";
  };
}
