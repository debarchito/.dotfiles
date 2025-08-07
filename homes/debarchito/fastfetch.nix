{
  programs.fastfetch = {
    enable = true;
    settings = {
      # Ported from https://github.com/TheToxicToast/fastfetch-config
      logo = {
        source = "~/.config/fastfetch/cat.txt";
        type = "auto";
        height = 15;
        width = 26;
        padding = {
          top = 0;
          left = 2;
          right = 6;
        };
      };
      modules = [
        {
          type = "os";
          key = " OS";
          keyColor = "magenta";
        }
        {
          type = "packages";
          key = " Packages";
          keyColor = "magenta";
        }
        {
          type = "uptime";
          key = " Uptime";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = " OS Age";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          keyColor = "magenta";
        }
      ];
    };
  };
  xdg.configFile."fastfetch/cat.txt".source = ./fastfetch/cat.txt;
}
