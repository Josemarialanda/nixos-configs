{
  description = "Nixos configurations";

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
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    configuration = config-variables: {
      nixosConfiguration = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs config-variables;
        };
        modules = [./hosts/${config-variables.hostname}/nixos/configuration.nix];
      };
      homeConfiguration = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs config-variables;};
        modules = [./hosts/${config-variables.hostname}/home-manager/home.nix];
      };
    };

    vm = configuration {
      stateVersion = "24.11";
      hostname = "vm";
      username = "nixos";
      userDesc = "Nixos VM";
    };
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # Rebuild shortcuts, e.g. `nix run .#switch` or `nix run .#home`.
    # Extra arguments are passed through, e.g. `nix run .#switch -- --show-trace`.
    apps = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      mkApp = name: text: {
        type = "app";
        program = nixpkgs.lib.getExe (pkgs.writeShellApplication {
          inherit name text;
          runtimeInputs = [pkgs.nixos-rebuild pkgs.hostname home-manager.packages.${system}.default];
        });
      };
      nixosRebuild = action: mkApp "nixos-${action}" ''
        nixos-rebuild ${action} --sudo --flake "${self}#$(hostname)" "$@"
      '';
    in {
      switch = nixosRebuild "switch";
      boot = nixosRebuild "boot";
      test = nixosRebuild "test";
      dry-build = nixosRebuild "dry-build";
      home = mkApp "home-switch" ''
        home-manager switch --flake "${self}#$(whoami)@$(hostname)" "$@"
      '';
      home-build = mkApp "home-build" ''
        home-manager build --flake "${self}#$(whoami)@$(hostname)" "$@"
      '';
    });

    nixosConfigurations = {
      vm = vm.nixosConfiguration;
    };

    homeConfigurations = {
      "nixos@vm" = vm.homeConfiguration "aarch64-linux";
    };
  };
}
