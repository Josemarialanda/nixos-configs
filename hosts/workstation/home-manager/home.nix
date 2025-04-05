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

  # SSH config.
  home.file = {
    ".ssh/config".text = ''
      Host github.com
        HostName github.com
        User git
        IdentityFile ${config.age.secrets.gh-ssh-key.path}
    '';
  };

  # Additional user packages.
  home.packages = with pkgs; [
    # Development.
    vscode-fhs
    meld
    gitg
    textpieces
    unstable.commit
    unstable.escambo
    unstable.wildcard
    squirrel-sql
    unstable.httpie-desktop

    # Cursor themes.
    phinger-cursors

    # Icon themes.
    papirus-icon-theme

    # Internet.
    google-chrome
    fragments

    # Media.
    stremio
    shortwave
    vlc
    libation
    spotify
    pitivi
    video-trimmer

    # Office.
    apostrophe
    drawing
    abiword
    unstable.morphosis

    # Utilities.
    endeavour
    ghostty
    warpinator
    kid3
    gnome-boxes
    bottles
    distrobox
    resources
    gnome-nettool
    impression
    pandoc
    fsearch
    pods
    raider
    unstable.inspector
    whatip

    # CLI tools.
    podman-compose
    appimage-run
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
          size.binaryPrefix = "si";
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
          key.Width = 6;
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
    # Ghostty config.
    ".config/ghostty/config".text = ''
      background-opacity = 0.95
      background-blur-radius = 15
      theme = Dracula
      background = #1e1f29
      foreground = #e6e6e6
      selection-background = #44475a
      selection-foreground = #ffffff
      cursor-color = #bbbbbb
      cursor-text = #ffffff
      cursor-style = bar
      palette = 0=#000000
      palette = 1=#ff5555
      palette = 2=#50fa7b
      palette = 3=#f1fa8c
      palette = 4=#bd93f9
      palette = 5=#ff79c6
      palette = 6=#8be9fd
      palette = 7=#bbbbbb
      palette = 8=#555555
      palette = 9=#ff5555
      palette = 10=#50fa7b
      palette = 11=#f1fa8c
      palette = 12=#bd93f9
      palette = 13=#ff79c6
      palette = 14=#8be9fd
      palette = 15=#ffffff
      font-size = 16
      mouse-hide-while-typing = true

    '';
  };
}
