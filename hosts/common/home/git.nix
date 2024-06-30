{
  programs = {  
    git = {
      enable = true;
      userName = "josemarialanda";
      userEmail = "josemaria.landa@gmail.com";
      difftastic.enable = true;
      aliases = { };
      ignores = ["nohup.out"];
      extraConfig = {
        init.defaultBranch = "main";        
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
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
  };
}