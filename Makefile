.PHONY: switch

switch:
	nix run github:nix-community/home-manager -- switch -b backup --flake .#mbp
