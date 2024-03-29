{ config, pkgs, lib, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      window = {
        opacity = 1;
        dynamic_title = true;
        dynamic_padding = true;
        decorations = "full";
        dimensions = { lines = 0; columns = 0; };
        padding = { x = 5; y = 5; };
      };


      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      mouse = { hide_when_typing = true; };

      key_bindings = [
        {
          # clear terminal
          key = "L";
          mods = "Control";
          chars = "\\x0c";
        }
      ];

      font = let fontname = "Pragmata Pro Mono Liga"; in
        {
          normal = {
            family = fontname;
            style = "Regular";
          };
          size = 12;
        };

      cursor.style = "Block";

      colors = {
        primary = {
          background = "0x1f1f28";
          foreground = "0xdcd7ba";
        };
        normal = {
          black = "0x090618";
          red = "0xc34043";
          green = "0x76946a";
          yellow = "0xc0a36e";
          blue = "0x7e9cd8";
          magenta = "0x957fb8";
          cyan = "0x6a9589";
          white = "0xc8c093";
        };
        bright = {
          black = "0x727169";
          red = "0xe82424";
          green = "0x98bb6c";
          yellow = "0xe6c384";
          blue = "0x7fb4ca";
          magenta = "0x938aa9";
          cyan = "0x7aa89f";
          white = "0xdcd7ba";
        };
        selection = {
          background = "0x2d4f67";
          foreground = "0xc8c093";
        };
        indexed_colors = [
          { index = 16; color = "0xffa066"; }
          { index = 17; color = "0xff5d62"; }
        ];
      };
    };
  };
}
