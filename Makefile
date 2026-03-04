.PHONY: install-nix switch setup

# Nixをインストール
install-nix:
	@if command -v nix >/dev/null 2>&1; then \
		echo "Nix is already installed, skipping..."; \
	else \
		curl -L https://nixos.org/nix/install | sh; \
	fi

# 設定を適用（nix-darwin経由でhome-manager + homebrewも管理）
switch:
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
		sudo darwin-rebuild switch --flake .#mbp; \
	else \
		echo "darwin-rebuild not found, bootstrapping via nix run..."; \
		nix build .#darwinConfigurations.mbp.system && sudo ./result/activate; \
	fi

# 初回セットアップ（Nix未インストールの場合）
setup: install-nix switch
