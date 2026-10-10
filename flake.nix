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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    pkgsFor = system: nixpkgs.legacyPackages.${system};

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
          runtimeInputs = [pkgs.nixos-rebuild pkgs.hostname home-manager.packages.${system}.default];
        });
      };
      nixosRebuild = action:
        mkApp "nixos-${action}" ''
          nixos-rebuild ${action} --sudo --flake "${self}#$(hostname)" "$@"
        '';
      homeManager = action:
        mkApp "home-${action}" ''
          home-manager ${action} --flake "${self}#$(whoami)@$(hostname)" "$@"
        '';
    in {
      switch = nixosRebuild "switch";
      boot = nixosRebuild "boot";
      test = nixosRebuild "test";
      dry-build = nixosRebuild "dry-build";
      home = homeManager "switch";
      home-build = homeManager "build";
    });

    nixosConfigurations = lib.mapAttrs (_: mkNixos) hosts;
    homeConfigurations = lib.mapAttrs' (_: host: lib.nameValuePair "${host.username}@${host.hostname}" (mkHome host)) hosts;
  };
}
