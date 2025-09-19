{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
    extensions = [
      pkgs.gh-f
      pkgs.gh-i
      pkgs.gh-markdown-preview
      pkgs.gh-notify
      pkgs.gh-s
    ];
  };
}
