{
  # Git configuration
  programs.git = {
    enable = true;
    ignores = ["nohup.out"];
    settings = {
      user.name = "josemarialanda";
      user.email = "josemaria.landa@gmail.com";
      alias = {};
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull = {
        ff = "only";
        rebase = true;
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
      };
    };
  };

  # Structural diffs for git.
  programs.difftastic = {
    enable = true;
    git.enable = true;
  };
}
