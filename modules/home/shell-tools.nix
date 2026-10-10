{
  # Prompt.
  programs.starship.enable = true;

  # Smarter `cd` that learns frequent directories (`cdi` picks one with fzf).
  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };

  # Fuzzy finder; binds Ctrl-R (history), Ctrl-T (files) and Alt-C (cd).
  programs.fzf.enable = true;

  # `cat` with syntax highlighting.
  programs.bat.enable = true;
  programs.bash.shellAliases.cat = "bat --paging=never";

  # `ls` replacement; also aliases ls, ll, la, lt and lla to eza.
  programs.eza = {
    enable = true;
    git = true;
  };
}
