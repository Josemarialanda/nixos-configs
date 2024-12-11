{
  description = "Nixos configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

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

    workstation = configuration {
      # Don't change the original stateVersion, it's used to track the version of the configuration.
      stateVersion = "24.05";
      hostname = "workstation";
      username = "josemaria";
      userDesc = "Nixos Workstation";
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

    nixosConfigurations = {
      workstation = workstation.nixosConfiguration;
      vm = vm.nixosConfiguration;
    };

    homeConfigurations = {
      "josemaria@workstation" = workstation.homeConfiguration "x86_64-linux";
      "nixos@vm" = vm.homeConfiguration "aarch64-linux";
    };
  };
}
