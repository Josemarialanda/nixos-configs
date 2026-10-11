{config, ...}: {
  imports = [
    ../../modules/home
    ./claude
  ];

  home.packages = [];

  # Log in once with `gh auth login`. gh keeps the token in ~/.config/gh/hosts.yml.
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  age.secrets.gh-ssh-key = {
    file = ./secrets/gh-ssh-key.age;
    path = "${config.home.homeDirectory}/.ssh/gh-ssh-key";
    mode = "600";
  };

  home.file.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ${config.age.secrets.gh-ssh-key.path}
  '';
}
