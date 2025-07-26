{
  description = ''
     beginning my starter nixos config

    One of the best ways to learn NIXOS is to read other peoples configurations. I have personally learned a lot from Gabriel Fontes configs:
    https://github.com/Misterio77/nix-starter-configs
    https://github.com/Misterio77/nix-config

    Please also check out the starter configs mentioned above.
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nvim-config = {
      url = "git+https://github.com/henrybley/nvim.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      home-manager,
      stylix,
      nvim-config,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        think-duck = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/think-duck
            stylix.nixosModules.stylix
          ];
        };
        desk-duck = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/desk-duck
            stylix.nixosModules.stylix
          ];
        };
      };
      homeConfigurations = {
        "ducky@think-duck" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/ducky/think-duck.nix
            stylix.homeManagerModules.stylix
          ];
        };
        "ducky@desk-duck" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/ducky/desk-duck.nix
            stylix.homeManagerModules.stylix
          ];
        };
      };
    };
}
