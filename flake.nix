{
  description = "Flake-based NixOS setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        cora = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/cora/configuration.nix ];
        };

        corapad = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/corapad/configuration.nix ];
        };
      };

      homeConfigurations = {
        "bened@cora" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
