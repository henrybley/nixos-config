{
  description = ''
    Nixos Config
  '';
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix.url = "github:musnix/musnix";
    nvim-config = {
      url = "git+https://github.com/henrybley/nvim.git";
      flake = false;
    };
    duckshell = {
      url = "git+https://github.com/henrybley/duckshell.git";
      #url = "path:/home/ducky/.config/duckshell";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      stylix,
      nvim-config,
      duckshell,
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
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.users.ducky = import ./home/ducky/think-duck.nix;
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                duckshell.homeManagerModules.default
              ];
            }
          ];
        };
        desk-duck = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/desk-duck
            stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
            inputs.musnix.nixosModules.musnix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.users.ducky = import ./home/ducky/desk-duck.nix;
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                duckshell.homeManagerModules.default
              ];
            }
          ];
        };
      };
      # Keep standalone configs for manual testing if needed
      # homeConfigurations = {
      #   "ducky@think-duck" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
      #     extraSpecialArgs = { inherit inputs outputs; };
      #     modules = [
      #       ./home/ducky/think-duck.nix
      #       stylix.homeManagerModules.stylix
      #       inputs.sops-nix.homeManagerModules.sops
      #       duckshell.homeManagerModules.default
      #     ];
      #   };
      #   "ducky@desk-duck" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
      #     extraSpecialArgs = { inherit inputs outputs; };
      #     modules = [
      #       ./home/ducky/desk-duck.nix
      #       stylix.homeManagerModules.stylix
      #       inputs.sops-nix.homeManagerModules.sops
      #       duckshell.homeManagerModules.default
      #     ];
      #   };
      # };
    };
}
