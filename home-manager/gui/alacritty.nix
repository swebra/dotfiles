{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 5;
        };
        dynamic_padding = true;
        decorations = "None";
        opacity = 0.95;
      };
      font = {
        normal.family = "MesloLGS Nerd Font";
        size = 13;
      };
      colors = {
        primary = {
          background = "#282C34";
          foreground = "#ABB2BF";
        };
        normal = {
          black = "#282c34";
          red = "#e06c75";
          green = "#98c379";
          yellow = "#e5c07b";
          blue = "#61afef";
          magenta = "#c678dd";
          cyan = "#56b6c2";
          white = "#abb2bf";
        };
        bright = {
          black = "#454c59";
          red = "#ff7a85";
          green = "#b5e890";
          yellow = "#ffd68a";
          blue = "#69bbff";
          magenta = "#e48aff";
          cyan = "#66d9e8";
          white = "#cfd7e6";
        };
      };
      cursor.style.shape = "Beam";
    };
  };
}
