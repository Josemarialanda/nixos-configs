{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    git-hooks,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    pkgsFor = system: nixpkgs.legacyPackages.${system};

    # Pre-commit hooks, installed into .git/hooks when entering the dev shell.
    preCommitFor = system:
      git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          # Lints are configured in statix.toml.
          statix = {
            enable = true;
            excludes = ["hardware-configuration\\.nix$"];
          };
          deadnix = {
            enable = true;
            excludes = ["hardware-configuration\\.nix$"];
          };
        };
      };

    # Adding a host: add an entry here and create hosts/<hostname>/{configuration,home}.nix.
    hosts = {
      vm = {
        hostname = "vm";
        system = "aarch64-linux";
        username = "nixos";
        userDesc = "Nixos VM";
        stateVersion = "24.11";
      };
    };

    mkNixos = host:
      lib.nixosSystem {
        specialArgs = {inherit inputs host;};
        modules = [./hosts/${host.hostname}/configuration.nix];
      };

    mkHome = host:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit (host) system;
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        };
        extraSpecialArgs = {inherit inputs host;};
        modules = [./hosts/${host.hostname}/home.nix];
      };
  in {
    packages = forAllSystems (system: import ./pkgs (pkgsFor system));
    formatter = forAllSystems (system: (pkgsFor system).alejandra);

    checks = forAllSystems (system: {
      pre-commit = preCommitFor system;
    });

    # `nix develop` (or direnv via .envrc) for working on this repo.
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
      preCommit = preCommitFor system;
    in {
      default = pkgs.mkShell {
        packages = preCommit.enabledPackages ++ [pkgs.nixd];
        inherit (preCommit) shellHook;
      };
    });
    overlays = import ./overlays {inherit inputs;};

    # Rebuild shortcuts, e.g. `nix run .#switch` or `nix run .#home`.
    # Extra arguments are passed through, e.g. `nix run .#switch -- --show-trace`.
    apps = forAllSystems (system: let
      pkgs = pkgsFor system;
      mkApp = name: text: {
        type = "app";
        meta.description = "Run ${name} for the current host";
        program = lib.getExe (pkgs.writeShellApplication {
          inherit name text;
          runtimeInputs = [pkgs.nh];
        });
      };
      # nh picks nixosConfigurations.<hostname> and homeConfigurations."<user>@<hostname>".
      nhOs = action:
        mkApp "nixos-${action}" ''
          nh os ${action} "path:${self}" "$@"
        '';
      nhHome = action:
        mkApp "home-${action}" ''
          nh home ${action} "path:${self}" "$@"
        '';
    in {
      switch = nhOs "switch";
      boot = nhOs "boot";
      test = nhOs "test";
      dry-build = mkApp "nixos-dry-build" ''
        nh os build --dry "path:${self}" "$@"
      '';
      home = nhHome "switch";
      home-build = nhHome "build";
    });

    nixosConfigurations = lib.mapAttrs (_: mkNixos) hosts;
    homeConfigurations = lib.mapAttrs' (_: host: lib.nameValuePair "${host.username}@${host.hostname}" (mkHome host)) hosts;
  };
}
