{ inputs, outputs, lib, config, pkgs, config-variables, ... }:

{
  programs.home-manager.enable = true;
  home.username = config-variables.username;
  home.homeDirectory = "/home/" + config-variables.username;
  home.stateVersion = config-variables.stateVersion;
  
  imports = [
    ../../common/home
  ];

    home.packages = with pkgs; [
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

}