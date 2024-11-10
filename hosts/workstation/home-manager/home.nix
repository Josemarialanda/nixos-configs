{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  config-variables,
  ...
}: {
  programs.home-manager.enable = true;
  home.username = config-variables.username;
  home.homeDirectory = "/home/" + config-variables.username;
  home.stateVersion = config-variables.stateVersion;

  imports = [
    ../../common/home
    inputs.nix-colors.homeManagerModules.default
  ];

  # Setup SSH keys.
  age.secrets = {
    gh-ssh-key = {
      file = ./secrets/gh-ssh-key.age;
      path = "/home/${config-variables.username}/.ssh/gh-ssh-key";
      mode = "600";
    };
    id_ed25519 = {
      file = ./secrets/id_ed25519.age;
      path = "/home/${config-variables.username}/.ssh/id_ed25519";
      mode = "600";
    };
  };

  # Setup SSH config.
  home.file = {
    ".ssh/config".text = ''
      Host homelab
        HostName homelab
        User nixos
        Port 22
        IdentityFile ${config.age.secrets.id_ed25519.path}
    '';
  };

  home.packages = let
    cli-tools = import ../../common/cli-tools.nix;
  in
    with pkgs; [
      # Development.
      vscode-fhs
      meld
      gitg
      textpieces

      # Cursor themes.
      phinger-cursors

      # Icon themes.
      papirus-icon-theme

      # Internet.
      google-chrome
      fragments
      mumble

      # Media.
      stremio
      shortwave
      vlc
      unstable.parabolic
      monophony
      spotify
      pitivi
      video-trimmer

      # Office.
      apostrophe

      # Utilities.
      tilix
      gnome.gnome-boxes
      bottles
      distrobox
      unstable.mission-center
      gnome.gnome-nettool
      impression
      pandoc
      fsearch
      bleachbit
      pods
      raider

      # CLI tools.
      podman-compose
      appimage-run
      bottom
      pfetch
      ssh-tools
      wget
      ffmpeg
      ripgrep
      tree
      multitail
      jq
      fx
      jp
      yq
      up
      rmlint
      with-shell
      steam-run
      trash-cli
      retry
      concurrently
      http-prompt
      detox
      git-sync
      sox
      catimg
      bc
      clac
      rlwrap
      wtf
      pipr
    ];

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

    # Enable Cava bar spectrum audio visualizer.
    cava = {
      enable = true;
      settings = {
        general = {
          framerate = 144;
          autosens = 1;
          sensitivity = 50;
          bars = 0;
          bar_width = 0;
          bar_spacing = 1;
          lower_cutoff_freq = 20;
          higher_cutoff_freq = 20000;
        };
        input = {
          show_idle_bar_heads = 1;
          waveform = 1;
        };
        smoothing = {
          waves = 1;
          noise_reduction = 90;
        };
        color = {
          background = "'#${config.colorScheme.palette.base00}'";
          foreground = "'#${config.colorScheme.palette.base05}'";
        };
      };
    };

    # Enable MangoHud.
    mangohud = {
      enable = true;
      settings = {
        gpu_temp = "1";
        cpu_temp = "1";
        vram = "1";
        ram = "1";
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

    bash = {
      # Bash config file
      bashrcExtra = ''
      '';

      # Commands that should be run when initializing an interactive shell
      initExtra = ''
      '';
    };
  };

  # Global color scheme.
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-pale;

  home.file = {
    # Theme for tilix.
    ".config/tilix/schemes/GlobalColorScheme.json".text = ''
      {
        "background-color": "#${config.colorScheme.palette.base00}",
        "badge-color": "#FFFFFF",
        "bold-color": "#FFFFFF",
        "comment": "",
        "cursor-background-color": "#000000",
        "cursor-foreground-color": "#FFFFFF",
        "foreground-color": "#${config.colorScheme.palette.base05}",
        "highlight-background-color": "#000000",
        "highlight-foreground-color": "#FFFFFF",
        "name": "Global Color Scheme",
        "palette": [
          "#${config.colorScheme.palette.base00}",
          "#${config.colorScheme.palette.base01}",
          "#${config.colorScheme.palette.base02}",
          "#${config.colorScheme.palette.base03}",
          "#${config.colorScheme.palette.base04}",
          "#${config.colorScheme.palette.base05}",
          "#${config.colorScheme.palette.base06}",
          "#${config.colorScheme.palette.base07}",
          "#${config.colorScheme.palette.base08}",
          "#${config.colorScheme.palette.base09}",
          "#${config.colorScheme.palette.base0A}",
          "#${config.colorScheme.palette.base0B}",
          "#${config.colorScheme.palette.base0C}",
          "#${config.colorScheme.palette.base0D}",
          "#${config.colorScheme.palette.base0E}",
          "#${config.colorScheme.palette.base0F}"
        ],
        "use-badge-color": false,
        "use-bold-color": false,
        "use-cursor-color": false,
        "use-highlight-color": false,
        "use-theme-colors": false
      }
    '';
  };
}
