{
  description = ''
    Nixos Config
  '';
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
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
      #url = "git+https://github.com/henrybley/duckshell.git";
      url = "git+file:/home/ducky/.config/duckshell";
      inputs.nixpkgs.follows = "nixpkgs";
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
              ];
            }
          ];
        };
      };
    };
}
