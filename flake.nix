{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    configuration = config-variables: {
      nixosConfiguration = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs config-variables;};
        modules = [ ./hosts/${config-variables.hostname}/nixos/configuration.nix ];
      };
      homeConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs config-variables;};
        modules = [ ./hosts/${config-variables.hostname}/home-manager/home.nix ];
      };
    };

    homelab = configuration {
      stateVersion = "24.05";
      hostname = "homelab";
      username = "nixos";
      userDesc = "Nixos Homelab";
    };

    workstation = configuration {
      stateVersion = "24.05";
      hostname = "workstation";
      username = "josemaria";
      userDesc = "Nixos Workstation";
    };

    vm = configuration {
      stateVersion = "24.05";
      hostname = "vm";
      username = "josemaria";
      userDesc = "Nixos VM";
    };

  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {
      homelab = homelab.nixosConfiguration;
      workstation = workstation.nixosConfiguration;
      vm = vm.nixosConfiguration;
    };
    homeConfigurations = {
      "nixos@homelab" = homelab.homeConfiguration;
      "josemaria@workstation" = workstation.homeConfiguration;
      "josemaria@vm" = vm.homeConfiguration;
    };
  };
}
