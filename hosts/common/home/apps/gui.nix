{ inputs, outputs, lib, config, pkgs, config-variables, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  options = {
    gui.enable = lib.mkEnableOption "Enable GUI apps";
  };

  config = lib.mkIf config.gui.enable {
    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
      ];
      config = {
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ ];
      };
    };
  
    home.packages = with pkgs; [
  
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
    ];
  
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
  };
}