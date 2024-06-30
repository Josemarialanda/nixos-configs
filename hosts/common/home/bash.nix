{
    programs = {  
      # Bash configuration
      bash = {
        enable = true;
    
        # Shell aliases
        shellAliases = {
  
          # Show active SSH connections (IP address and hostname)
          active-ssh-connections = "netstat -tnp -W 2>/dev/null | awk '$6 == \"ESTABLISHED\" && $4 ~ /:22$/ {split($5, a, \":\"); cmd = \"host \" a[1]; cmd | getline hostname; close(cmd); split(hostname, b, \" \"); print a[1], \"(\" b[5] \")\"; exit}'";
  
          # Check if there are active SSH connections
          has-ssh-connections = "netstat -tnp -W 2>/dev/null | awk '\$6 == \"ESTABLISHED\" && \$4 ~ /:22\$/ {print \"true\"; found = 1; exit} END { if (found != 1) print \"false\" }'";
    
          # Variations of ls
          ll = "ls -l";
          lo = "ls -o";
          lh = "ls -lh";
          la = "ls -la";
    
          # confirm before overwriting something
          "cp" = "cp -i";
          "mv" = "mv -i";
          "rm" = "rm -i";
    
          # git
          addup = "git add -u";
          addall = "git add .";
          branch = "git branch";
    	    checkout = "git checkout";
    	    clone = "git clone";
    	    commit = "git commit -m";
    	    fetch = "git fetch";
    	    pull = "git pull origin";
    	    push = "git push origin";
    	    stat = "git status";
    	    tag = "git tag";
    	    newtag = "git tag -a";
    
          # get error messages from journalctl
          jctl = "journalctl -p 3 -xb";
             
          # Disk space information
          diskspace = "du -S | sort -n -r |more";
        
          # Show the size (sorted) of the folders in this directory
          folders = "find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn";
    
          # Aliases for moving up directories
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          "....." = "cd ../../../..";
  
          # System managemant aliases.
          nos = "nh os switch -- --impure";
          nob = "nh os boot -- --impure";
          nhs = "nh home switch";
          nhas = ''
            nh os switch -- --impure
            nh home switch
          '';
          nhab = ''
            nh os boot -- --impure
            nh home switch
          '';
        };
  
        # Bash config file
        bashrcExtra = ''
        '';
          
        # Commands that should be run when initializing an interactive shell
        initExtra = ''
        '';
      };
    };
}