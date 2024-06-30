{ inputs, outputs, lib, config, pkgs, config-variables, ... }:

{
  programs.home-manager.enable = true;
  home.username = config-variables.username;
  home.homeDirectory = "/home/" + config-variables.username;
  home.stateVersion = config-variables.stateVersion;
  
  imports = [
    ../../common/home
  ];

  apps.common.include = "all";

  # Configurable programs.
  programs = {

    # Enable FastFetch: A system information fetching tool.
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          color = {
            "1" = "blue";
            "2" = "white";
          };
          padding = {
            top = 2;
            left = 1;
            right = 1;
          };
        };
        display = {
          separator = "";
          binaryPrefix = "si";
          size = {
            ndigits = 0;
          };
          percent = {
            type = 2;
          };
          bar = {
            charElapsed = "";
            charTotal = " ";
          };
          keyWidth = 6;
        };
        modules = [
          {
            type = "title";
            color = {
              user = "35";
              host = "36";
            };
          }
          {
            type = "separator";
            string = "▔";
          }
          {
            type = "host";
            key = "├─󰟀";
            keyColor = "32";
          }
          {
            type = "os";
            key = "╭─";
            format = "{3}";
            keyColor = "32";
          }
          {
            type = "kernel";
            key = "├─󰒔";
            format = "{2}";
            keyColor = "32";
          }
          {
            type = "shell";
            key = "├─$";
            format = "{1} {4}";
            keyColor = "32";
          }
          {
            type = "uptime";
            key = "╰─󰔚";
            keyColor = "32";
          }
          "break"
          {
            type = "cpu";
            key = "╭─";
            keyColor = "34";
            freqNdigits = 1;
          }
          {
            type = "gpu";
            key = "├─󰢮";
            format = "{1} {2}";
            keyColor = "34";
          }
          {
            type = "memory";
            key = "├─";
            keyColor = "34";
          }
          {
            type = "disk";
            key = "├─󰋊";
            keyColor = "34";
          }
          "break"
          {
            type = "display";
            key = "╭─󰹑";
            keyColor = "33";
            compactType = "original";
          }
          {
            type = "de";
            key = "├─󰧨";
            keyColor = "33";
          }
          {
            type = "wm";
            key = "├─";
            keyColor = "33";
          }
          {
            type = "theme";
            key = "├─󰉼";
            keyColor = "33";
          }
          {
            type = "icons";
            key = "├─";
            keyColor = "33";
          }
          {
            type = "cursor";
            key = "├─󰳽";
            keyColor = "33";
          }
          {
            type = "font";
            key = "├─";
            format = "{2}";
            keyColor = "33";
          }
          {
            type = "terminal";
            key = "╰─";
            format = "{3}";
            keyColor = "33";
          }
          "break"
          {
            type = "colors";
          }
        ];
      };
    };
    
    # Enable MangoHud.
    mangohud = {
      enable = true;
      settings = {
        gpu_temp = "1";
        cpu_temp = "1";
        vram     = "1";
        ram      = "1";
      };
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        character = {
          success_symbol = "⚡";
          error_symbol = "🔥";
        };
        cmd_duration = {
          min_time = 500;
          format = "🕑:[$duration](bold yellow)";
        };
      };
    };
  };

  # Create additional desktop shortcuts.
  xdg.desktopEntries = {
    # Desktop entry for the Invoke AI web app.
    invoke-ai = {
      name = "Invoke AI";
      exec = ''nix run github:nixified-ai/flake"#"invokeai-amd'';
      terminal = true;
      type = "Application";
      icon = pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Circle-icons-art.svg/512px-Circle-icons-art.svg.png";
        sha256 = "sha256-9P4I1FXi55mE8Rw1d2FZwbO2MPkzbB3hy54ool4tGGo=";
      };
    };

    # Desktop entry for the Invoke AI development shell.
    invoke-ai-shell = {
      name = "Invoke AI shell";
      exec = ''nix shell github:nixified-ai/flake"#"invokeai-amd'';
      terminal = true;
      type = "Application";
      icon = pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Windows_Settings_icon.svg/512px-Windows_Settings_icon.svg.png";
        sha256 = "sha256-D3gm/8KTqBwuPL9DXDWoGxqV/vhLIjDmKGxbdbmWtvs=";
      };
    };
  };
}