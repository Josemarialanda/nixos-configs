{config, ...}: {
  imports = [
    ../../modules/home
    ./claude
  ];

  home.packages = [];

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
