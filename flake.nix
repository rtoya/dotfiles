{
  description = "dotfiles (macOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }:
    let
      system = "aarch64-darwin";
      username = "ryotoya";
      homeDirectory = "/Users/${username}";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations.mbp = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeModules.nixvim
          ./home/home.nix
        ];
        extraSpecialArgs = {
          inherit username homeDirectory;
        };
      };
    };
}
