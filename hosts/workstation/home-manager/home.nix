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

  age.secrets = {
    gh-ssh-key = {
      file = ./secrets/gh-ssh-key.age;
      path = "/home/${config-variables.username}/.ssh/gh-ssh-key";
      mode = "600";
    };
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

      # Gnome tweaks, customization and extensions.
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.dash-to-dock
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.app-hider
      adwsteamgtk

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
        fastfetch
      '';
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

  # Global color scheme.
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-pale;

  # Custom keybindings.
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "tilix";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "rofi launcher";
      command = "rofi -show drun";
      binding = "<Alt>Return";
    };
  };

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

    # Theme for rofi.
    ".local/share/rofi/themes/GlobalColorScheme.rasi".text = ''
      configuration {
        font: "FiraCode-Retina 14";
        drun {
          display-name: "Applications";
        }
        run {
          display-name: "Run";
        }
        window {
          display-name: "Windows";
        }
        timeout {
          delay: 10;
          action: "kb-cancel";
        }
      }
      * {
        width: 30%;
        border: 0;
        margin: 0;
        padding: 0;
        spacing: 0;
        bg: #${config.colorScheme.palette.base00};
        bg-alt: #${config.colorScheme.palette.base02};
        fg: #${config.colorScheme.palette.base05};
        selectedElem: #${config.colorScheme.palette.base0D};
        background-color: @bg;
        text-color: @fg;
      }
      window {
        transparency: "real";
      }
      mainbox {
        children: [inputbar, listview];
      }
      inputbar {
        background-color: @bg-alt;
        children: [prompt, entry];
      }
      entry {
        background-color: inherit;
        padding: 12px 3px;
      }
      prompt {
        background-color: inherit;
        padding: 12px;
      }
      listview {
        lines: 8;
      }
      element {
        children: [element-icon, element-text];
      }
      element-icon {
        padding: 10px 10px;
      }
      element-text {
        padding: 10px 0;
        text-color: @fg;
      }
      element-text selected {
        text-color: @selectedElem;
      }
    '';
  };
}
