{
  description = "dotfiles (macOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
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
          ./home/home.nix
          ./home/hosts/mbp.nix
        ];
        extraSpecialArgs = {
          inherit username homeDirectory;
        };
      };
    };
}

